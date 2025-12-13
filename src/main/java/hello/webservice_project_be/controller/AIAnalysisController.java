package hello.webservice_project_be.controller;

import org.json.JSONObject;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/api/ai-analysis")
public class AIAnalysisController {
    
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
        System.err.println("[AIAnalysisController] 경고: OPENAI_API_KEY 환경 변수 또는 openai.api.key 시스템 프로퍼티가 설정되지 않았습니다.");
        return null;
    }
    
    @PostMapping
    @ResponseBody
    public ResponseEntity<?> analyze(@RequestBody Map<String, String> request, HttpSession session) {
        try {
            String projectData = request.get("projectData");
            String analysisType = request.getOrDefault("analysisType", "summary");
            
            String analysisResult = callOpenAI(projectData, analysisType);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("analysis", analysisResult);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "AI 분석 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }
    
    private String callOpenAI(String projectData, String analysisType) throws Exception {
        // OpenAI API 키 확인
        String apiKey = getOpenAIApiKey();
        if (apiKey == null || apiKey.isEmpty()) {
            throw new Exception("OpenAI API 키가 설정되지 않았습니다. OPENAI_API_KEY 환경 변수를 설정해주세요.");
        }
        
        URL url = new URL(OPENAI_API_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        
        try {
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Authorization", "Bearer " + apiKey);
            conn.setDoOutput(true);
            
            String prompt = buildPrompt(projectData, analysisType);
            
            JSONObject requestBody = new JSONObject();
            requestBody.put("model", "gpt-3.5-turbo");
            
            JSONObject message = new JSONObject();
            message.put("role", "user");
            message.put("content", prompt);
            
            requestBody.put("messages", new org.json.JSONArray().put(message));
            requestBody.put("max_tokens", 1000);
            requestBody.put("temperature", 0.7);
            
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
                BufferedReader errorReader = new BufferedReader(
                    new InputStreamReader(conn.getErrorStream(), "UTF-8"));
                StringBuilder errorResponse = new StringBuilder();
                String errorLine;
                
                while ((errorLine = errorReader.readLine()) != null) {
                    errorResponse.append(errorLine);
                }
                errorReader.close();
                
                System.err.println("OpenAI API 오류 응답: " + errorResponse.toString());
                throw new Exception("OpenAI API 호출 실패: HTTP " + responseCode);
            }
        } finally {
            conn.disconnect();
        }
    }
    
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

