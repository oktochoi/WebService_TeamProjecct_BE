package hello.webservice_project_be.service;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class GitHubService {
    
    /**
     * GitHub 저장소 URL에서 저장소 정보를 추출합니다.
     * 예: https://github.com/username/repo -> username/repo
     */
    public String extractRepoPath(String repoUrl) {
        if (repoUrl == null || repoUrl.isEmpty()) {
            return null;
        }
        
        // localhost나 유효하지 않은 URL 체크
        if (repoUrl.contains("localhost") || repoUrl.contains("127.0.0.1") || 
            !repoUrl.contains("github.com")) {
            System.err.println("[GitHubService] 유효하지 않은 GitHub URL: " + repoUrl);
            return null;
        }
        
        // https://github.com/username/repo 형식에서 username/repo 추출
        String[] parts = repoUrl.replace("https://github.com/", "")
                               .replace("http://github.com/", "")
                               .replace("github.com/", "")
                               .replace(".git", "")
                               .split("/");
        
        if (parts.length >= 2 && !parts[0].isEmpty() && !parts[1].isEmpty()) {
            return parts[0] + "/" + parts[1];
        }
        
        System.err.println("[GitHubService] 저장소 경로 추출 실패: " + repoUrl);
        return null;
    }
    
    /**
     * GitHub API를 통해 저장소 정보를 가져옵니다.
     */
    public Map<String, Object> getRepositoryInfo(String repoUrl) throws Exception {
        String repoPath = extractRepoPath(repoUrl);
        if (repoPath == null) {
            throw new Exception("유효하지 않은 GitHub 저장소 URL입니다.");
        }
        
        String apiUrl = "https://api.github.com/repos/" + repoPath;
        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        
        try {
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/vnd.github.v3+json");
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(10000);
            
            int responseCode = conn.getResponseCode();
            
            if (responseCode == HttpURLConnection.HTTP_OK) {
                BufferedReader in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), "UTF-8"));
                StringBuilder response = new StringBuilder();
                String inputLine;
                
                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
                in.close();
                
                JSONObject repoInfo = new JSONObject(response.toString());
                
                Map<String, Object> result = new HashMap<>();
                result.put("name", repoInfo.optString("name", ""));
                result.put("description", repoInfo.optString("description", ""));
                result.put("fullName", repoInfo.optString("full_name", ""));
                result.put("stars", repoInfo.optInt("stargazers_count", 0));
                result.put("forks", repoInfo.optInt("forks_count", 0));
                result.put("language", repoInfo.optString("language", ""));
                result.put("createdAt", repoInfo.optString("created_at", ""));
                result.put("updatedAt", repoInfo.optString("updated_at", ""));
                
                return result;
            } else if (responseCode == HttpURLConnection.HTTP_NOT_FOUND) {
                throw new Exception("저장소를 찾을 수 없습니다.");
            } else {
                throw new Exception("GitHub API 호출 실패: HTTP " + responseCode);
            }
        } finally {
            conn.disconnect();
        }
    }
    
    /**
     * GitHub API를 통해 저장소의 기여자 정보를 가져옵니다.
     */
    public List<Map<String, Object>> getContributors(String repoUrl) throws Exception {
        String repoPath = extractRepoPath(repoUrl);
        if (repoPath == null) {
            throw new Exception("유효하지 않은 GitHub 저장소 URL입니다.");
        }
        
        String apiUrl = "https://api.github.com/repos/" + repoPath + "/contributors";
        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        
        try {
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/vnd.github.v3+json");
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(10000);
            
            int responseCode = conn.getResponseCode();
            
            if (responseCode == HttpURLConnection.HTTP_OK) {
                BufferedReader in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), "UTF-8"));
                StringBuilder response = new StringBuilder();
                String inputLine;
                
                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
                in.close();
                
                JSONArray contributors = new JSONArray(response.toString());
                List<Map<String, Object>> result = new ArrayList<>();
                
                for (int i = 0; i < contributors.length(); i++) {
                    JSONObject contributor = contributors.getJSONObject(i);
                    Map<String, Object> contrib = new HashMap<>();
                    contrib.put("username", contributor.optString("login", ""));
                    contrib.put("contributions", contributor.optInt("contributions", 0));
                    result.add(contrib);
                }
                
                return result;
            } else {
                // 기여자 정보가 없어도 빈 리스트 반환
                return new ArrayList<>();
            }
        } finally {
            conn.disconnect();
        }
    }
    
    /**
     * GitHub API를 통해 저장소의 통계 정보를 가져옵니다.
     */
    public Map<String, Object> getRepositoryStats(String repoUrl) throws Exception {
        String repoPath = extractRepoPath(repoUrl);
        if (repoPath == null) {
            throw new Exception("유효하지 않은 GitHub 저장소 URL입니다.");
        }
        
        Map<String, Object> stats = new HashMap<>();
        
        // 저장소 정보
        Map<String, Object> repoInfo = getRepositoryInfo(repoUrl);
        stats.put("repoInfo", repoInfo);
        
        // 기여자 정보
        List<Map<String, Object>> contributors = getContributors(repoUrl);
        stats.put("contributors", contributors);
        stats.put("memberCount", contributors.size());
        
        // 총 기여도 계산 (간단한 합계)
        int totalContributions = 0;
        for (Map<String, Object> contrib : contributors) {
            totalContributions += (Integer) contrib.get("contributions");
        }
        stats.put("totalContributions", totalContributions);
        
        return stats;
    }
    
    /**
     * GitHub API를 통해 저장소의 총 커밋 수를 가져옵니다.
     * 참고: GitHub API는 커밋 수를 직접 제공하지 않으므로, 최근 커밋들을 페이지네이션으로 가져와서 추정합니다.
     */
    public int getTotalCommits(String repoUrl) throws Exception {
        String repoPath = extractRepoPath(repoUrl);
        if (repoPath == null) {
            throw new Exception("유효하지 않은 GitHub 저장소 URL입니다.");
        }
        
        // GitHub API는 전체 커밋 수를 직접 제공하지 않으므로,
        // contributors API의 contributions 합계를 사용하거나
        // 최근 커밋들을 샘플링하여 추정합니다.
        // 여기서는 contributors의 contributions 합계를 사용합니다.
        List<Map<String, Object>> contributors = getContributors(repoUrl);
        int totalCommits = 0;
        for (Map<String, Object> contrib : contributors) {
            totalCommits += (Integer) contrib.get("contributions");
        }
        return totalCommits;
    }
    
    /**
     * GitHub API를 통해 저장소의 Pull Requests 수를 가져옵니다.
     */
    public int getTotalPullRequests(String repoUrl) throws Exception {
        String repoPath = extractRepoPath(repoUrl);
        if (repoPath == null) {
            throw new Exception("유효하지 않은 GitHub 저장소 URL입니다.");
        }
        
        String apiUrl = "https://api.github.com/repos/" + repoPath + "/pulls?state=all&per_page=100";
        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        
        try {
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/vnd.github.v3+json");
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(10000);
            
            int responseCode = conn.getResponseCode();
            
            if (responseCode == HttpURLConnection.HTTP_OK) {
                // Link 헤더에서 페이지 정보 확인
                String linkHeader = conn.getHeaderField("Link");
                int totalPRs = 0;
                
                // 첫 페이지의 PR 수 계산
                BufferedReader in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), "UTF-8"));
                StringBuilder response = new StringBuilder();
                String inputLine;
                
                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
                in.close();
                
                JSONArray pulls = new JSONArray(response.toString());
                totalPRs = pulls.length();
                
                // Link 헤더가 있으면 마지막 페이지 번호 확인
                if (linkHeader != null && linkHeader.contains("rel=\"last\"")) {
                    // Link 헤더 파싱: <https://api.github.com/repos/.../pulls?state=all&page=5>; rel="last"
                    String lastPageUrl = linkHeader.split("rel=\"last\"")[0].trim();
                    if (lastPageUrl.contains("page=")) {
                        String pageNum = lastPageUrl.substring(lastPageUrl.lastIndexOf("page=") + 5);
                        pageNum = pageNum.replace(">", "").replace(";", "").trim();
                        try {
                            int lastPage = Integer.parseInt(pageNum);
                            // 마지막 페이지의 PR 수를 가져와서 더 정확하게 계산
                            if (lastPage > 1) {
                                totalPRs = (lastPage - 1) * 100; // 대략적인 추정
                            }
                        } catch (NumberFormatException e) {
                            // 파싱 실패 시 첫 페이지 결과만 사용
                        }
                    }
                }
                
                return totalPRs;
            } else {
                return 0;
            }
        } finally {
            conn.disconnect();
        }
    }
    
    /**
     * GitHub API를 통해 저장소의 Issues 수를 가져옵니다.
     */
    public int getTotalIssues(String repoUrl) throws Exception {
        String repoPath = extractRepoPath(repoUrl);
        if (repoPath == null) {
            throw new Exception("유효하지 않은 GitHub 저장소 URL입니다.");
        }
        
        String apiUrl = "https://api.github.com/repos/" + repoPath + "/issues?state=all&per_page=100";
        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        
        try {
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/vnd.github.v3+json");
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(10000);
            
            int responseCode = conn.getResponseCode();
            
            if (responseCode == HttpURLConnection.HTTP_OK) {
                String linkHeader = conn.getHeaderField("Link");
                int totalIssues = 0;
                
                BufferedReader in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), "UTF-8"));
                StringBuilder response = new StringBuilder();
                String inputLine;
                
                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
                in.close();
                
                JSONArray issues = new JSONArray(response.toString());
                // Pull Requests는 issues에 포함되므로 제외해야 함
                for (int i = 0; i < issues.length(); i++) {
                    JSONObject issue = issues.getJSONObject(i);
                    // pull_request 필드가 없으면 실제 issue
                    if (!issue.has("pull_request")) {
                        totalIssues++;
                    }
                }
                
                // Link 헤더 파싱
                if (linkHeader != null && linkHeader.contains("rel=\"last\"")) {
                    String lastPageUrl = linkHeader.split("rel=\"last\"")[0].trim();
                    if (lastPageUrl.contains("page=")) {
                        String pageNum = lastPageUrl.substring(lastPageUrl.lastIndexOf("page=") + 5);
                        pageNum = pageNum.replace(">", "").replace(";", "").trim();
                        try {
                            int lastPage = Integer.parseInt(pageNum);
                            if (lastPage > 1) {
                                // 대략적인 추정 (정확하지 않을 수 있음)
                                totalIssues = (lastPage - 1) * 100;
                            }
                        } catch (NumberFormatException e) {
                            // 파싱 실패 시 첫 페이지 결과만 사용
                        }
                    }
                }
                
                return totalIssues;
            } else {
                return 0;
            }
        } finally {
            conn.disconnect();
        }
    }
    
    /**
     * GitHub API를 통해 저장소의 상세 통계 정보를 가져옵니다.
     */
    public Map<String, Object> getDetailedRepositoryStats(String repoUrl) throws Exception {
        String repoPath = extractRepoPath(repoUrl);
        if (repoPath == null) {
            throw new Exception("유효하지 않은 GitHub 저장소 URL입니다: " + repoUrl);
        }
        
        System.out.println("[GitHubService] 저장소 경로 추출 성공: " + repoPath);
        
        Map<String, Object> stats = getRepositoryStats(repoUrl);
        
        try {
            // 커밋 수
            int totalCommits = getTotalCommits(repoUrl);
            stats.put("totalCommits", totalCommits);
            System.out.println("[GitHubService] 총 커밋 수: " + totalCommits);
        } catch (Exception e) {
            System.err.println("[GitHubService] 커밋 수 가져오기 실패: " + e.getMessage());
            stats.put("totalCommits", 0);
        }
        
        try {
            // Pull Requests 수
            int totalPRs = getTotalPullRequests(repoUrl);
            stats.put("totalPullRequests", totalPRs);
            System.out.println("[GitHubService] 총 Pull Requests 수: " + totalPRs);
        } catch (Exception e) {
            System.err.println("[GitHubService] Pull Requests 수 가져오기 실패: " + e.getMessage());
            stats.put("totalPullRequests", 0);
        }
        
        try {
            // Issues 수
            int totalIssues = getTotalIssues(repoUrl);
            stats.put("totalIssues", totalIssues);
            System.out.println("[GitHubService] 총 Issues 수: " + totalIssues);
        } catch (Exception e) {
            System.err.println("[GitHubService] Issues 수 가져오기 실패: " + e.getMessage());
            stats.put("totalIssues", 0);
        }
        
        return stats;
    }
}

