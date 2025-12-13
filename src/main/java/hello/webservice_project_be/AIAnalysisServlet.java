package hello.webservice_project_be;

import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;

@WebServlet(name = "aiAnalysisServlet", value = "/api/ai-analysis")
public class AIAnalysisServlet extends HttpServlet {
    
    private static final String OPENAI_API_URL = "https://api.openai.com/v1/chat/completions";
    
    /**
     * OpenAI API 키를 환경 변수 또는 시스템 프로퍼티에서 가져옵니다.
     */
    private String getOpenAIApiKey() {
        // 1. 환경 변수에서 확인
        String apiKey = System.getenv("OPENAI_API_KEY");
        if (apiKey != null && !apiKey.isEmpty()) {
            return apiKey;
        }
        
        // 2. 시스템 프로퍼티에서 확인
        apiKey = System.getProperty("openai.api.key");
        if (apiKey != null && !apiKey.isEmpty()) {
            return apiKey;
        }
        
        // 3. 없으면 null 반환 (에러 처리)
        System.err.println("[AIAnalysisServlet] 경고: OPENAI_API_KEY 환경 변수 또는 openai.api.key 시스템 프로퍼티가 설정되지 않았습니다.");
        return null;
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("authenticated") == null || 
            !(Boolean) session.getAttribute("authenticated")) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print(new JSONObject().put("error", "인증이 필요합니다.").toString());
            return;
        }
        
        try {
            // 요청 본문 읽기
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                sb.append(line);
            }
            
            JSONObject requestJson = new JSONObject(sb.toString());
            String projectData = requestJson.optString("projectData", "");
            String analysisType = requestJson.optString("analysisType", "summary");
            
            // OpenAI API 호출
            String analysisResult = callOpenAI(projectData, analysisType);
            
            JSONObject responseJson = new JSONObject();
            responseJson.put("success", true);
            responseJson.put("analysis", analysisResult);
            
            out.print(responseJson.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JSONObject errorJson = new JSONObject();
            errorJson.put("error", "AI 분석 중 오류가 발생했습니다: " + e.getMessage());
            out.print(errorJson.toString());
        }
    }
    
    /**
     * OpenAI API를 호출하여 프로젝트 분석을 수행합니다.
     */
    private String callOpenAI(String projectData, String analysisType) throws IOException {
        // OpenAI API 키 확인
        String apiKey = getOpenAIApiKey();
        if (apiKey == null || apiKey.isEmpty()) {
            throw new IOException("OpenAI API 키가 설정되지 않았습니다. OPENAI_API_KEY 환경 변수를 설정해주세요.");
        }
        
        URL url = new URL(OPENAI_API_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        
        try {
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Authorization", "Bearer " + apiKey);
            conn.setDoOutput(true);
            
            // 프롬프트 구성
            String prompt = buildPrompt(projectData, analysisType);
            
            // 요청 본문 구성
            JSONObject requestBody = new JSONObject();
            requestBody.put("model", "gpt-3.5-turbo");
            
            JSONObject message = new JSONObject();
            message.put("role", "user");
            message.put("content", prompt);
            
            requestBody.put("messages", new org.json.JSONArray().put(message));
            requestBody.put("max_tokens", 1000);
            requestBody.put("temperature", 0.7);
            
            // 요청 전송
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = requestBody.toString().getBytes("utf-8");
                os.write(input, 0, input.length);
            }
            
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
                
                JSONObject jsonResponse = new JSONObject(response.toString());
                if (jsonResponse.has("choices") && jsonResponse.getJSONArray("choices").length() > 0) {
                    JSONObject choice = jsonResponse.getJSONArray("choices").getJSONObject(0);
                    JSONObject messageObj = choice.getJSONObject("message");
                    return messageObj.getString("content");
                } else {
                    return "AI 분석 결과를 가져올 수 없습니다.";
                }
            } else {
                // 에러 응답 읽기
                BufferedReader errorReader = new BufferedReader(
                    new InputStreamReader(conn.getErrorStream(), "UTF-8"));
                StringBuilder errorResponse = new StringBuilder();
                String errorLine;
                
                while ((errorLine = errorReader.readLine()) != null) {
                    errorResponse.append(errorLine);
                }
                errorReader.close();
                
                System.err.println("OpenAI API 오류 응답: " + errorResponse.toString());
                throw new IOException("OpenAI API 호출 실패: HTTP " + responseCode);
            }
        } finally {
            conn.disconnect();
        }
    }
    
    /**
     * 분석 타입에 따라 프롬프트를 구성합니다.
     */
    private String buildPrompt(String projectData, String analysisType) {
        String basePrompt = "다음은 GitHub 프로젝트의 데이터입니다:\n\n" + projectData + "\n\n";
        
        switch (analysisType) {
            case "summary":
                return basePrompt + "이 프로젝트에 대한 종합적인 분석을 한국어로 작성해주세요. " +
                       "프로젝트의 주요 특징, 팀원들의 기여도, 개선 사항 등을 포함해주세요.";
            case "contribution":
                return basePrompt + "각 팀원의 기여도를 분석하고 평가해주세요. " +
                       "커밋 수, 코드 리뷰, 이슈 해결 등의 활동을 종합적으로 고려하여 한국어로 작성해주세요.";
            case "improvement":
                return basePrompt + "이 프로젝트의 개선 사항과 권장 사항을 한국어로 작성해주세요. " +
                       "코드 품질, 협업 방식, 프로세스 개선 등을 포함해주세요.";
            default:
                return basePrompt + "이 프로젝트에 대한 상세 분석을 한국어로 작성해주세요.";
        }
    }
}

