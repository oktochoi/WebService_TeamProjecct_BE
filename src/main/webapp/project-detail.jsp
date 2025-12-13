<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%
    String projectId = request.getParameter("id");
    // 기본값을 설정하지 않음 - ID가 없으면 JavaScript에서 처리
    if (projectId == null || projectId.trim().isEmpty()) {
        projectId = null;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>프로젝트 상세 - 노오력지수</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            background-color: #0d1117;
            color: #e5e7eb;
        }
    </style>
</head>
<body>
    <div class="flex min-h-screen bg-[#0d1117]">
        <!-- Sidebar -->
        <aside class="w-64 bg-[#161b22] border-r border-gray-800 fixed h-screen flex flex-col">
            <div class="p-6 border-b border-gray-800">
                <a href="index.jsp" class="flex items-center gap-2 cursor-pointer">
                    <div class="w-8 h-8 bg-gradient-to-br from-blue-500 to-purple-600 rounded-lg flex items-center justify-center">
                        <i class="ri-bar-chart-box-line text-white text-lg"></i>
                    </div>
                    <span class="text-xl font-bold text-white">노오력지수</span>
                </a>
            </div>

            <nav class="p-4 flex-1 overflow-y-auto">
                <div class="mb-6">
                    <p class="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-3 px-4">메뉴</p>
                    <a href="dashboard.jsp" class="flex items-center gap-3 px-4 py-3 rounded-lg mb-1 transition-colors cursor-pointer text-gray-400 hover:bg-gray-800 hover:text-white">
                        <i class="ri-dashboard-line text-xl"></i>
                        <span>대시보드</span>
                    </a>
                    <a href="dashboard.jsp" class="flex items-center gap-3 px-4 py-3 rounded-lg mb-1 transition-colors cursor-pointer bg-blue-600 text-white">
                        <i class="ri-folder-line text-xl"></i>
                        <span>프로젝트</span>
                    </a>
                    <a href="#" class="flex items-center gap-3 px-4 py-3 rounded-lg mb-1 transition-colors cursor-pointer text-gray-400 hover:bg-gray-800 hover:text-white">
                        <i class="ri-team-line text-xl"></i>
                        <span>팀원 관리</span>
                    </a>
                    <a href="#" class="flex items-center gap-3 px-4 py-3 rounded-lg mb-1 transition-colors cursor-pointer text-gray-400 hover:bg-gray-800 hover:text-white">
                        <i class="ri-bar-chart-box-line text-xl"></i>
                        <span>통계</span>
                    </a>
                    <a href="#" class="flex items-center gap-3 px-4 py-3 rounded-lg mb-1 transition-colors cursor-pointer text-gray-400 hover:bg-gray-800 hover:text-white">
                        <i class="ri-star-line text-xl"></i>
                        <span>리뷰 관리</span>
                    </a>
                    <a href="settings.jsp" class="flex items-center gap-3 px-4 py-3 rounded-lg mb-1 transition-colors cursor-pointer text-gray-400 hover:bg-gray-800 hover:text-white">
                        <i class="ri-settings-3-line text-xl"></i>
                        <span>설정</span>
                    </a>
                </div>
            </nav>

            <div class="p-4 border-t border-gray-800">
                <div class="flex items-center gap-3 px-4 py-3 bg-gray-800/50 rounded-lg mb-3">
                    <div class="w-9 h-9 bg-gradient-to-br from-purple-500 to-pink-500 rounded-full flex items-center justify-center">
                        <span class="text-white font-semibold text-sm">
                            <% 
                                if (session != null && session.getAttribute("name") != null) {
                                    String name = (String) session.getAttribute("name");
                                    if (name != null && !name.isEmpty()) {
                                        out.print(name.substring(0, 1));
                                    } else {
                                        out.print("U");
                                    }
                                } else {
                                    out.print("U");
                                }
                            %>
                        </span>
                    </div>
                    <div class="flex-1 min-w-0">
                        <p class="text-sm font-medium text-white truncate">
                            <% 
                                if (session != null && session.getAttribute("name") != null) {
                                    out.print(session.getAttribute("name"));
                                } else {
                                    out.print("사용자");
                                }
                            %>
                        </p>
                        <p class="text-xs text-gray-400 truncate">
                            <% 
                                if (session != null && session.getAttribute("email") != null) {
                                    out.print(session.getAttribute("email"));
                                } else {
                                    out.print("email@example.com");
                                }
                            %>
                        </p>
                    </div>
                </div>
                <a href="logout" class="flex items-center gap-3 px-4 py-3 rounded-lg text-gray-400 hover:bg-gray-800 hover:text-white transition-colors cursor-pointer">
                    <i class="ri-logout-box-line text-xl"></i>
                    <span>로그아웃</span>
                </a>
            </div>
        </aside>

        <div class="flex-1 ml-64">
            <nav class="border-b border-gray-800 bg-[#161b22] sticky top-0 z-10">
                <div class="px-8 py-4">
                    <div class="flex items-center justify-between">
                        <div class="flex items-center gap-4">
                            <a href="dashboard.jsp" class="w-9 h-9 flex items-center justify-center text-gray-400 hover:bg-gray-800 rounded-lg transition-colors cursor-pointer">
                                <i class="ri-arrow-left-line text-xl"></i>
                            </a>
                            <div>
                                <h1 class="text-xl font-semibold text-white" id="projectTitle">프로젝트 로딩 중...</h1>
                                <div class="flex items-center gap-2 text-sm text-gray-400 mt-1">
                                    <i class="ri-git-repository-line"></i>
                                    <span id="projectRepo">-</span>
                                </div>
                            </div>
                        </div>
                        <div class="flex items-center gap-3">
                            <button 
                                onclick="performAIAnalysis()"
                                id="aiAnalysisBtn"
                                class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors flex items-center gap-2 whitespace-nowrap cursor-pointer"
                            >
                                <i class="ri-robot-line"></i>
                                AI 재분석
                            </button>
                        </div>
                    </div>
                </div>
            </nav>

            <div class="px-8 py-8">
            <div class="flex gap-2 mb-6 border-b border-gray-800">
                <button
                    onclick="switchTab('overview')"
                    id="tab-overview"
                    class="px-4 py-2 font-medium transition-colors flex items-center gap-2 border-b-2 border-blue-500 text-white whitespace-nowrap cursor-pointer"
                >
                    <i class="ri-file-list-line"></i>
                    개요
                </button>
                <button
                    onclick="switchTab('contributors')"
                    id="tab-contributors"
                    class="px-4 py-2 font-medium transition-colors flex items-center gap-2 border-b-2 border-transparent text-gray-400 hover:text-white whitespace-nowrap cursor-pointer"
                >
                    <i class="ri-team-line"></i>
                    팀원
                </button>
                <button
                    onclick="switchTab('analysis')"
                    id="tab-analysis"
                    class="px-4 py-2 font-medium transition-colors flex items-center gap-2 border-b-2 border-transparent text-gray-400 hover:text-white whitespace-nowrap cursor-pointer"
                >
                    <i class="ri-robot-line"></i>
                    AI 분석
                </button>
                <button
                    onclick="switchTab('reviews')"
                    id="tab-reviews"
                    class="px-4 py-2 font-medium transition-colors flex items-center gap-2 border-b-2 border-transparent text-gray-400 hover:text-white whitespace-nowrap cursor-pointer"
                >
                    <i class="ri-chat-3-line"></i>
                    리뷰
                </button>
            </div>

            <!-- Overview Tab -->
            <div id="content-overview" class="tab-content">
                <!-- 로딩 상태 -->
                <div id="loadingState" class="text-center py-12">
                    <i class="ri-loader-4-line animate-spin text-4xl text-blue-400 mb-4"></i>
                    <p class="text-gray-400">프로젝트 정보를 불러오는 중...</p>
                </div>
                
                <!-- 프로젝트 정보 (로딩 완료 후 표시) -->
                <div id="projectContent" class="space-y-6 hidden">
                    <div class="p-6 rounded-lg border border-gray-800 bg-[#161b22]">
                        <h2 class="text-lg font-semibold text-white mb-4">프로젝트 정보</h2>
                        <div class="space-y-3">
                            <div>
                                <p class="text-sm text-gray-400 mb-1">설명</p>
                                <p class="text-gray-200" id="projectDescription">-</p>
                            </div>
                            <div class="grid grid-cols-3 gap-4 pt-4 border-t border-gray-800">
                                <div>
                                    <p class="text-sm text-gray-400 mb-1">생성일</p>
                                    <p class="font-medium text-white" id="projectCreatedAt">-</p>
                                </div>
                                <div>
                                    <p class="text-sm text-gray-400 mb-1">팀원 수</p>
                                    <p class="font-medium text-white" id="projectMembers">-</p>
                                </div>
                                <div>
                                    <p class="text-sm text-gray-400 mb-1">상태</p>
                                    <span class="inline-block px-2 py-1 text-xs font-medium rounded-full whitespace-nowrap" id="projectStatus">-</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="grid grid-cols-4 gap-4">
                        <div class="p-6 rounded-lg border border-gray-800 bg-[#161b22]">
                            <div class="flex items-center gap-3 mb-2">
                                <div class="w-10 h-10 flex items-center justify-center bg-blue-900/30 rounded-lg">
                                    <i class="ri-git-commit-line text-xl text-blue-400"></i>
                                </div>
                                <div>
                                    <p class="text-2xl font-bold text-white" id="totalCommits">0</p>
                                    <p class="text-sm text-gray-400">총 커밋</p>
                                </div>
                            </div>
                        </div>
                        <div class="p-6 rounded-lg border border-gray-800 bg-[#161b22]">
                            <div class="flex items-center gap-3 mb-2">
                                <div class="w-10 h-10 flex items-center justify-center bg-purple-900/30 rounded-lg">
                                    <i class="ri-git-pull-request-line text-xl text-purple-400"></i>
                                </div>
                                <div>
                                    <p class="text-2xl font-bold text-white" id="totalPullRequests">0</p>
                                    <p class="text-sm text-gray-400">Pull Requests</p>
                                </div>
                            </div>
                        </div>
                        <div class="p-6 rounded-lg border border-gray-800 bg-[#161b22]">
                            <div class="flex items-center gap-3 mb-2">
                                <div class="w-10 h-10 flex items-center justify-center bg-green-900/30 rounded-lg">
                                    <i class="ri-error-warning-line text-xl text-green-400"></i>
                                </div>
                                <div>
                                    <p class="text-2xl font-bold text-white" id="totalIssues">0</p>
                                    <p class="text-sm text-gray-400">이슈</p>
                                </div>
                            </div>
                        </div>
                        <div class="p-6 rounded-lg border border-gray-800 bg-[#161b22]">
                            <div class="flex items-center gap-3 mb-2">
                                <div class="w-10 h-10 flex items-center justify-center bg-orange-900/30 rounded-lg">
                                    <i class="ri-star-line text-xl text-orange-400"></i>
                                </div>
                                <div>
                                    <p class="text-2xl font-bold text-white" id="contributionScore">0</p>
                                    <p class="text-sm text-gray-400">기여도 점수</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Contributors Tab -->
            <div id="content-contributors" class="tab-content hidden">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <a href="profile.jsp?username=oktochoi" class="block p-6 rounded-lg border border-gray-800 bg-[#161b22] hover:border-gray-700 transition-colors cursor-pointer">
                        <div class="flex items-start justify-between mb-4">
                            <div class="flex items-center gap-3">
                                <div class="w-12 h-12 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-semibold text-lg">
                                    OK
                                </div>
                                <div>
                                    <h3 class="font-semibold text-white">oktochoi</h3>
                                    <p class="text-sm text-gray-400">Owner</p>
                                </div>
                            </div>
                            <div class="text-right">
                                <div class="text-2xl font-bold text-white">95</div>
                                <div class="text-xs text-gray-400">기여도 점수</div>
                            </div>
                        </div>
                        <div class="grid grid-cols-2 gap-4">
                            <div class="p-3 rounded-lg bg-[#0d1117]">
                                <div class="flex items-center gap-2 mb-1">
                                    <i class="ri-git-commit-line text-blue-400"></i>
                                    <span class="text-sm text-gray-400">커밋</span>
                                </div>
                                <p class="text-xl font-semibold text-white">145</p>
                            </div>
                            <div class="p-3 rounded-lg bg-[#0d1117]">
                                <div class="flex items-center gap-2 mb-1">
                                    <i class="ri-git-pull-request-line text-purple-400"></i>
                                    <span class="text-sm text-gray-400">PR</span>
                                </div>
                                <p class="text-xl font-semibold text-white">23</p>
                            </div>
                            <div class="p-3 rounded-lg bg-[#0d1117]">
                                <div class="flex items-center gap-2 mb-1">
                                    <i class="ri-error-warning-line text-green-400"></i>
                                    <span class="text-sm text-gray-400">이슈</span>
                                </div>
                                <p class="text-xl font-semibold text-white">12</p>
                            </div>
                            <div class="p-3 rounded-lg bg-[#0d1117]">
                                <div class="flex items-center gap-2 mb-1">
                                    <i class="ri-chat-check-line text-orange-400"></i>
                                    <span class="text-sm text-gray-400">리뷰</span>
                                </div>
                                <p class="text-xl font-semibold text-white">34</p>
                            </div>
                        </div>
                    </a>
                    <a href="profile.jsp?username=devjohn" class="block p-6 rounded-lg border border-gray-800 bg-[#161b22] hover:border-gray-700 transition-colors cursor-pointer">
                        <div class="flex items-start justify-between mb-4">
                            <div class="flex items-center gap-3">
                                <div class="w-12 h-12 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-semibold text-lg">
                                    DJ
                                </div>
                                <div>
                                    <h3 class="font-semibold text-white">devjohn</h3>
                                    <p class="text-sm text-gray-400">Contributor</p>
                                </div>
                            </div>
                            <div class="text-right">
                                <div class="text-2xl font-bold text-white">82</div>
                                <div class="text-xs text-gray-400">기여도 점수</div>
                            </div>
                        </div>
                        <div class="grid grid-cols-2 gap-4">
                            <div class="p-3 rounded-lg bg-[#0d1117]">
                                <div class="flex items-center gap-2 mb-1">
                                    <i class="ri-git-commit-line text-blue-400"></i>
                                    <span class="text-sm text-gray-400">커밋</span>
                                </div>
                                <p class="text-xl font-semibold text-white">98</p>
                            </div>
                            <div class="p-3 rounded-lg bg-[#0d1117]">
                                <div class="flex items-center gap-2 mb-1">
                                    <i class="ri-git-pull-request-line text-purple-400"></i>
                                    <span class="text-sm text-gray-400">PR</span>
                                </div>
                                <p class="text-xl font-semibold text-white">18</p>
                            </div>
                            <div class="p-3 rounded-lg bg-[#0d1117]">
                                <div class="flex items-center gap-2 mb-1">
                                    <i class="ri-error-warning-line text-green-400"></i>
                                    <span class="text-sm text-gray-400">이슈</span>
                                </div>
                                <p class="text-xl font-semibold text-white">8</p>
                            </div>
                            <div class="p-3 rounded-lg bg-[#0d1117]">
                                <div class="flex items-center gap-2 mb-1">
                                    <i class="ri-chat-check-line text-orange-400"></i>
                                    <span class="text-sm text-gray-400">리뷰</span>
                                </div>
                                <p class="text-xl font-semibold text-white">21</p>
                            </div>
                        </div>
                    </a>
                    <a href="profile.jsp?username=codemaster" class="block p-6 rounded-lg border border-gray-800 bg-[#161b22] hover:border-gray-700 transition-colors cursor-pointer">
                        <div class="flex items-start justify-between mb-4">
                            <div class="flex items-center gap-3">
                                <div class="w-12 h-12 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-semibold text-lg">
                                    CM
                                </div>
                                <div>
                                    <h3 class="font-semibold text-white">codemaster</h3>
                                    <p class="text-sm text-gray-400">Contributor</p>
                                </div>
                            </div>
                            <div class="text-right">
                                <div class="text-2xl font-bold text-white">74</div>
                                <div class="text-xs text-gray-400">기여도 점수</div>
                            </div>
                        </div>
                        <div class="grid grid-cols-2 gap-4">
                            <div class="p-3 rounded-lg bg-[#0d1117]">
                                <div class="flex items-center gap-2 mb-1">
                                    <i class="ri-git-commit-line text-blue-400"></i>
                                    <span class="text-sm text-gray-400">커밋</span>
                                </div>
                                <p class="text-xl font-semibold text-white">76</p>
                            </div>
                            <div class="p-3 rounded-lg bg-[#0d1117]">
                                <div class="flex items-center gap-2 mb-1">
                                    <i class="ri-git-pull-request-line text-purple-400"></i>
                                    <span class="text-sm text-gray-400">PR</span>
                                </div>
                                <p class="text-xl font-semibold text-white">15</p>
                            </div>
                            <div class="p-3 rounded-lg bg-[#0d1117]">
                                <div class="flex items-center gap-2 mb-1">
                                    <i class="ri-error-warning-line text-green-400"></i>
                                    <span class="text-sm text-gray-400">이슈</span>
                                </div>
                                <p class="text-xl font-semibold text-white">6</p>
                            </div>
                            <div class="p-3 rounded-lg bg-[#0d1117]">
                                <div class="flex items-center gap-2 mb-1">
                                    <i class="ri-chat-check-line text-orange-400"></i>
                                    <span class="text-sm text-gray-400">리뷰</span>
                                </div>
                                <p class="text-xl font-semibold text-white">19</p>
                            </div>
                        </div>
                    </a>
                    <a href="profile.jsp?username=techguru" class="block p-6 rounded-lg border border-gray-800 bg-[#161b22] hover:border-gray-700 transition-colors cursor-pointer">
                        <div class="flex items-start justify-between mb-4">
                            <div class="flex items-center gap-3">
                                <div class="w-12 h-12 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-semibold text-lg">
                                    TG
                                </div>
                                <div>
                                    <h3 class="font-semibold text-white">techguru</h3>
                                    <p class="text-sm text-gray-400">Contributor</p>
                                </div>
                            </div>
                            <div class="text-right">
                                <div class="text-2xl font-bold text-white">65</div>
                                <div class="text-xs text-gray-400">기여도 점수</div>
                            </div>
                        </div>
                        <div class="grid grid-cols-2 gap-4">
                            <div class="p-3 rounded-lg bg-[#0d1117]">
                                <div class="flex items-center gap-2 mb-1">
                                    <i class="ri-git-commit-line text-blue-400"></i>
                                    <span class="text-sm text-gray-400">커밋</span>
                                </div>
                                <p class="text-xl font-semibold text-white">54</p>
                            </div>
                            <div class="p-3 rounded-lg bg-[#0d1117]">
                                <div class="flex items-center gap-2 mb-1">
                                    <i class="ri-git-pull-request-line text-purple-400"></i>
                                    <span class="text-sm text-gray-400">PR</span>
                                </div>
                                <p class="text-xl font-semibold text-white">11</p>
                            </div>
                            <div class="p-3 rounded-lg bg-[#0d1117]">
                                <div class="flex items-center gap-2 mb-1">
                                    <i class="ri-error-warning-line text-green-400"></i>
                                    <span class="text-sm text-gray-400">이슈</span>
                                </div>
                                <p class="text-xl font-semibold text-white">4</p>
                            </div>
                            <div class="p-3 rounded-lg bg-[#0d1117]">
                                <div class="flex items-center gap-2 mb-1">
                                    <i class="ri-chat-check-line text-orange-400"></i>
                                    <span class="text-sm text-gray-400">리뷰</span>
                                </div>
                                <p class="text-xl font-semibold text-white">13</p>
                            </div>
                        </div>
                    </a>
                </div>
            </div>

            <!-- Analysis Tab -->
            <div id="content-analysis" class="tab-content hidden">
                <div class="space-y-6">
                    <div class="p-6 rounded-lg border border-gray-800 bg-[#161b22]">
                        <div class="flex items-center justify-between mb-4">
                            <div class="flex items-center gap-2">
                                <i class="ri-robot-line text-2xl text-purple-400"></i>
                                <h2 class="text-lg font-semibold text-white">AI 종합 분석</h2>
                            </div>
                            <button 
                                onclick="performAIAnalysis()"
                                class="px-3 py-1 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors flex items-center gap-2 text-sm cursor-pointer"
                            >
                                <i class="ri-refresh-line"></i>
                                새로 분석
                            </button>
                        </div>
                        <div id="aiAnalysisContent">
                            <div id="aiAnalysisDefault">
                                <p class="text-gray-300 mb-4">전체적으로 균형잡힌 팀 협업이 이루어지고 있습니다. oktochoi님이 프로젝트를 주도하며, 다른 팀원들도 적극적으로 참여하고 있습니다.</p>
                                <div class="space-y-2">
                                    <div class="flex items-start gap-2 p-3 rounded-lg bg-green-900/20 border border-green-800">
                                        <i class="ri-checkbox-circle-line text-green-400 text-lg mt-0.5"></i>
                                        <p class="text-sm text-green-300">코드 리뷰 문화가 잘 정착되어 있어 코드 품질이 높습니다</p>
                                    </div>
                                    <div class="flex items-start gap-2 p-3 rounded-lg bg-green-900/20 border border-green-800">
                                        <i class="ri-checkbox-circle-line text-green-400 text-lg mt-0.5"></i>
                                        <p class="text-sm text-green-300">이슈 관리가 체계적으로 이루어지고 있습니다</p>
                                    </div>
                                    <div class="flex items-start gap-2 p-3 rounded-lg bg-yellow-900/20 border border-yellow-800">
                                        <i class="ri-error-warning-line text-yellow-400 text-lg mt-0.5"></i>
                                        <p class="text-sm text-yellow-300">일부 팀원의 커밋 빈도가 낮아 더 적극적인 참여가 필요합니다</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="space-y-4">
                        <h2 class="text-lg font-semibold text-white">팀원별 상세 분석</h2>
                        <div class="p-6 rounded-lg border border-gray-800 bg-[#161b22]">
                            <div class="flex items-center justify-between mb-4">
                                <h3 class="font-semibold text-white">oktochoi</h3>
                                <div class="flex items-center gap-2">
                                    <div class="text-2xl font-bold text-white">95</div>
                                    <div class="text-sm text-gray-400">/ 100</div>
                                </div>
                            </div>
                            <div class="grid md:grid-cols-2 gap-4">
                                <div>
                                    <h4 class="text-sm font-medium text-green-400 mb-2 flex items-center gap-1">
                                        <i class="ri-thumb-up-line"></i>
                                        강점
                                    </h4>
                                    <ul class="space-y-1">
                                        <li class="text-sm text-gray-300 flex items-start gap-2">
                                            <i class="ri-check-line text-green-400 mt-0.5"></i>
                                            프로젝트 리더십
                                        </li>
                                        <li class="text-sm text-gray-300 flex items-start gap-2">
                                            <i class="ri-check-line text-green-400 mt-0.5"></i>
                                            코드 품질
                                        </li>
                                        <li class="text-sm text-gray-300 flex items-start gap-2">
                                            <i class="ri-check-line text-green-400 mt-0.5"></i>
                                            적극적인 코드 리뷰
                                        </li>
                                    </ul>
                                </div>
                                <div>
                                    <h4 class="text-sm font-medium text-orange-400 mb-2 flex items-center gap-1">
                                        <i class="ri-lightbulb-line"></i>
                                        개선 사항
                                    </h4>
                                    <ul class="space-y-1">
                                        <li class="text-sm text-gray-300 flex items-start gap-2">
                                            <i class="ri-arrow-right-line text-orange-400 mt-0.5"></i>
                                            문서화 개선
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Reviews Tab -->
            <div id="content-reviews" class="tab-content hidden">
                <div class="space-y-6">
                    <div class="p-6 rounded-lg border border-gray-800 bg-[#161b22]">
                        <h2 class="text-lg font-semibold text-white mb-2">팀원 리뷰</h2>
                        <p class="text-sm text-gray-400 mb-6">
                            각 팀원의 협업 능력과 기여도를 평가하고 개별 저장할 수 있습니다
                        </p>

                        <div class="space-y-6">
                            <div class="p-4 rounded-lg border border-gray-800 bg-[#0d1117]">
                                <div class="flex items-center justify-between mb-4">
                                    <div class="flex items-center gap-3">
                                        <div class="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-semibold">
                                            OK
                                        </div>
                                        <h3 class="font-medium text-white">oktochoi</h3>
                                    </div>
                                    <span id="saved-1" class="hidden flex items-center gap-1 text-sm text-green-400">
                                        <i class="ri-check-line"></i>
                                        저장됨
                                    </span>
                                </div>

                                <div class="mb-4">
                                    <label class="block text-sm font-medium text-gray-300 mb-2">
                                        평점
                                    </label>
                                    <div class="flex gap-2">
                                        <button onclick="setRating(1, 1)" class="w-10 h-10 flex items-center justify-center cursor-pointer">
                                            <i id="star-1-1" class="text-2xl ri-star-line text-gray-600"></i>
                                        </button>
                                        <button onclick="setRating(1, 2)" class="w-10 h-10 flex items-center justify-center cursor-pointer">
                                            <i id="star-1-2" class="text-2xl ri-star-line text-gray-600"></i>
                                        </button>
                                        <button onclick="setRating(1, 3)" class="w-10 h-10 flex items-center justify-center cursor-pointer">
                                            <i id="star-1-3" class="text-2xl ri-star-line text-gray-600"></i>
                                        </button>
                                        <button onclick="setRating(1, 4)" class="w-10 h-10 flex items-center justify-center cursor-pointer">
                                            <i id="star-1-4" class="text-2xl ri-star-line text-gray-600"></i>
                                        </button>
                                        <button onclick="setRating(1, 5)" class="w-10 h-10 flex items-center justify-center cursor-pointer">
                                            <i id="star-1-5" class="text-2xl ri-star-line text-gray-600"></i>
                                        </button>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label class="block text-sm font-medium text-gray-300 mb-2">
                                        코멘트
                                    </label>
                                    <textarea
                                        id="comment-1"
                                        rows="3"
                                        maxlength="500"
                                        class="w-full px-4 py-2 bg-[#161b22] border border-gray-700 rounded-lg text-gray-100 placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
                                        placeholder="@oktochoi에게 남길 피드백을 작성해주세요"
                                    ></textarea>
                                    <p class="text-xs text-gray-400 mt-1">
                                        <span id="count-1">0</span>/500
                                    </p>
                                </div>

                                <button
                                    onclick="saveReview(1)"
                                    class="w-full px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors font-medium whitespace-nowrap cursor-pointer flex items-center justify-center gap-2"
                                >
                                    <i class="ri-save-line"></i>
                                    리뷰 저장
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="p-6 rounded-lg border border-gray-800 bg-[#161b22]">
                        <h2 class="text-lg font-semibold text-white mb-2">프로젝트 전체 리뷰</h2>
                        <p class="text-sm text-gray-400 mb-4">
                            프로젝트 전반에 대한 의견을 작성해주세요
                        </p>
                        <textarea
                            id="projectReview"
                            rows="5"
                            maxlength="500"
                            class="w-full px-4 py-2 bg-[#161b22] border border-gray-700 rounded-lg text-gray-100 placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
                            placeholder="프로젝트에 대한 전반적인 평가와 개선 사항을 작성해주세요"
                        ></textarea>
                        <p class="text-xs text-gray-400 mt-1 mb-4">
                            <span id="projectReviewCount">0</span>/500
                        </p>
                        <button
                            onclick="saveProjectReview()"
                            class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors whitespace-nowrap cursor-pointer flex items-center gap-2"
                        >
                            <i class="ri-save-line"></i>
                            프로젝트 리뷰 저장
                        </button>
                    </div>
                </div>
            </div>
            </div>
        </div>
    </div>

    <script>
        let currentTab = 'overview';
        const ratings = {};
        let currentProject = null;

        // 프로젝트 데이터 로드
        async function loadProject() {
            // URL 파라미터에서 id 가져오기
            const urlParams = new URLSearchParams(window.location.search);
            let projectId = urlParams.get('id');
            
            console.log('[project-detail] URL 파라미터에서 가져온 ID:', projectId);
            console.log('[project-detail] 전체 URL:', window.location.href);
            console.log('[project-detail] URL 파라미터 전체:', window.location.search);
            
            // URL 파라미터에 없으면 JSP에서 받은 값 사용
            if (!projectId || projectId === '' || projectId === 'null' || projectId === 'undefined') {
                const jspProjectId = '<%= projectId %>';
                console.log('[project-detail] JSP에서 가져온 ID:', jspProjectId);
                if (jspProjectId && jspProjectId !== 'null' && jspProjectId !== 'undefined' && jspProjectId !== '') {
                    projectId = jspProjectId;
                }
            }
            
            console.log('[project-detail] 최종 projectId:', projectId, '타입:', typeof projectId);
            
            // projectId를 숫자로 변환 시도
            const numericId = parseInt(projectId, 10);
            if (isNaN(numericId) || numericId <= 0) {
                console.error('[project-detail] 유효하지 않은 프로젝트 ID:', projectId);
                alert('유효하지 않은 프로젝트 ID입니다. 대시보드로 돌아갑니다.');
                window.location.href = 'dashboard.jsp';
                return;
            }
            
            console.log('[project-detail] 숫자로 변환된 ID:', numericId);

            try {
                // 숫자 ID 사용
                const apiUrl = '<%= request.getContextPath() %>/api/projects/' + numericId;
                console.log('[project-detail] API URL:', apiUrl);
                
                const response = await fetch(apiUrl, {
                    method: 'GET',
                    credentials: 'same-origin',
                    headers: {
                        'Accept': 'application/json'
                    }
                });

                console.log('[project-detail] API 응답 상태:', response.status);

                if (response.status === 401) {
                    window.location.href = 'login.jsp';
                    return;
                }

                if (!response.ok) {
                    const errorText = await response.text();
                    console.error('[project-detail] API 오류:', errorText);
                    throw new Error('프로젝트를 불러올 수 없습니다. (HTTP ' + response.status + ')');
                }

                // 응답 본문을 안전하게 읽기
                let responseText = '';
                try {
                    responseText = await response.text();
                    console.log('[project-detail] 응답 본문:', responseText);
                    currentProject = JSON.parse(responseText);
                } catch (parseError) {
                    console.error('[project-detail] JSON 파싱 오류:', parseError);
                    console.error('[project-detail] 응답 본문:', responseText);
                    throw new Error('응답 데이터를 파싱할 수 없습니다.');
                }
                
                console.log('[project-detail] 프로젝트 데이터:', currentProject);
                
                if (!currentProject) {
                    throw new Error('프로젝트 데이터가 없습니다.');
                }
                
                // id 확인 (다양한 필드명 체크)
                const projectId = currentProject.id || currentProject.projectId;
                if (!projectId) {
                    console.error('[project-detail] 프로젝트 ID가 없습니다. 전체 데이터:', currentProject);
                    throw new Error('프로젝트 ID가 없습니다.');
                }
                
                // id가 없으면 추가
                if (!currentProject.id) {
                    currentProject.id = projectId;
                }
                
                // 로딩 상태 숨기고 콘텐츠 표시
                const loadingState = document.getElementById('loadingState');
                const projectContent = document.getElementById('projectContent');
                if (loadingState) loadingState.classList.add('hidden');
                if (projectContent) projectContent.classList.remove('hidden');
                
                displayProject(currentProject);
            } catch (error) {
                console.error('[project-detail] 프로젝트 로드 오류:', error);
                alert('프로젝트를 불러오는 중 오류가 발생했습니다: ' + error.message);
                window.location.href = 'dashboard.jsp';
            }
        }

        function displayProject(project) {
            // 프로젝트 제목
            document.getElementById('projectTitle').textContent = project.name || '프로젝트';
            
            // 저장소 URL
            if (project.repoUrl) {
                const repoPath = project.repoUrl.replace('https://github.com/', '').replace('.git', '');
                document.getElementById('projectRepo').textContent = repoPath;
            } else {
                document.getElementById('projectRepo').textContent = '저장소 없음';
            }

            // 설명
            document.getElementById('projectDescription').textContent = project.description || '설명이 없습니다.';

            // 생성일
            if (project.createdAt) {
                const date = new Date(project.createdAt);
                document.getElementById('projectCreatedAt').textContent = date.toLocaleDateString('ko-KR');
            }

            // 팀원 수
            document.getElementById('projectMembers').textContent = (project.members || 0) + '명';

            // 커밋 수
            document.getElementById('totalCommits').textContent = project.totalCommits || 0;

            // Pull Requests 수
            document.getElementById('totalPullRequests').textContent = project.totalPullRequests || 0;

            // Issues 수
            document.getElementById('totalIssues').textContent = project.totalIssues || 0;

            // 기여도 점수
            document.getElementById('contributionScore').textContent = project.contributionScore || 0;

            // 상태
            const statusEl = document.getElementById('projectStatus');
            statusEl.textContent = project.status || '진행중';
            const statusClass = project.status === '완료' ? 'bg-green-900/30 text-green-400' : 
                               project.status === '진행중' ? 'bg-blue-900/30 text-blue-400' : 
                               project.status === '분석중' ? 'bg-yellow-900/30 text-yellow-400' :
                               project.status === '오류' ? 'bg-red-900/30 text-red-400' :
                               'bg-gray-900/30 text-gray-400';
            statusEl.className = 'inline-block px-2 py-1 text-xs font-medium rounded-full whitespace-nowrap ' + statusClass;
        }

        // 페이지 로드 시 프로젝트 데이터 가져오기
        (function() {
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', loadProject);
            } else {
                loadProject();
            }
        })();

        function switchTab(tab) {
            // Hide all tabs
            document.querySelectorAll('.tab-content').forEach(content => {
                content.classList.add('hidden');
            });
            document.querySelectorAll('[id^="tab-"]').forEach(btn => {
                btn.classList.remove('border-blue-500', 'text-white');
                btn.classList.add('border-transparent', 'text-gray-400');
            });

            // Show selected tab
            document.getElementById('content-' + tab).classList.remove('hidden');
            const tabBtn = document.getElementById('tab-' + tab);
            tabBtn.classList.add('border-blue-500', 'text-white');
            tabBtn.classList.remove('border-transparent', 'text-gray-400');
            currentTab = tab;
        }

        function setRating(contributorId, rating) {
            ratings[contributorId] = rating;
            for (let i = 1; i <= 5; i++) {
                const star = document.getElementById('star-' + contributorId + '-' + i);
                if (i <= rating) {
                    star.classList.remove('ri-star-line', 'text-gray-600');
                    star.classList.add('ri-star-fill', 'text-yellow-500');
                } else {
                    star.classList.remove('ri-star-fill', 'text-yellow-500');
                    star.classList.add('ri-star-line', 'text-gray-600');
                }
            }
        }

        function saveReview(contributorId) {
            const rating = ratings[contributorId];
            if (!rating) {
                alert('평점을 선택해주세요');
                return;
            }
            const comment = document.getElementById('comment-' + contributorId).value;
            console.log('리뷰 저장:', { contributorId, rating, comment });
            document.getElementById('saved-' + contributorId).classList.remove('hidden');
        }

        function saveProjectReview() {
            const comment = document.getElementById('projectReview').value.trim();
            if (!comment) {
                alert('프로젝트 리뷰를 작성해주세요');
                return;
            }
            console.log('프로젝트 리뷰 저장:', comment);
        }

        // Character count
        document.getElementById('comment-1').addEventListener('input', function() {
            document.getElementById('count-1').textContent = this.value.length;
        });

        document.getElementById('projectReview').addEventListener('input', function() {
            document.getElementById('projectReviewCount').textContent = this.value.length;
        });

        async function performAIAnalysis() {
            const btn = document.getElementById('aiAnalysisBtn');
            const originalText = btn.innerHTML;
            btn.disabled = true;
            btn.innerHTML = '<i class="ri-loader-4-line animate-spin"></i> 분석 중...';
            
            const analysisContent = document.getElementById('aiAnalysisContent');
            const defaultContent = document.getElementById('aiAnalysisDefault');
            if (defaultContent) {
                defaultContent.style.display = 'none';
            }
            analysisContent.innerHTML = '<div class="text-center py-8"><i class="ri-loader-4-line animate-spin text-3xl text-purple-400 mb-4"></i><p class="text-gray-400">AI 분석을 수행하는 중...</p></div>';
            
            try {
                // 현재 프로젝트 데이터 사용
                if (!currentProject) {
                    throw new Error('프로젝트 데이터가 없습니다.');
                }

                const projectData = {
                    name: currentProject.name,
                    description: currentProject.description,
                    repoUrl: currentProject.repoUrl,
                    members: currentProject.members,
                    contributionScore: currentProject.contributionScore,
                    contributors: [] // TODO: GitHub API에서 기여자 정보 가져오기
                };
                
                const apiUrl = '<%= request.getContextPath() %>/api/ai-analysis';
                const response = await fetch(apiUrl, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        projectData: JSON.stringify(projectData),
                        analysisType: 'summary'
                    })
                });
                
                const result = await response.json();
                
                if (result.success && result.analysis) {
                    // 분석 결과를 포맷팅하여 표시
                    const analysisText = result.analysis;
                    const escapedText = escapeHtml(analysisText);
                    analysisContent.innerHTML = `
                        <div class="space-y-4">
                            <div class="p-4 rounded-lg bg-purple-900/20 border border-purple-800">
                                <h3 class="text-md font-semibold text-white mb-3">AI 분석 결과</h3>
                                <div class="text-gray-300 whitespace-pre-wrap leading-relaxed">` + escapedText + `</div>
                            </div>
                        </div>
                    `;
                } else {
                    throw new Error(result.error || 'AI 분석에 실패했습니다.');
                }
            } catch (error) {
                console.error('AI 분석 오류:', error);
                const errorMessage = escapeHtml(error.message || '알 수 없는 오류');
                analysisContent.innerHTML = `
                    <div class="p-4 rounded-lg bg-red-900/20 border border-red-800">
                        <p class="text-red-400 mb-2">AI 분석 중 오류가 발생했습니다</p>
                        <p class="text-red-300 text-sm">` + errorMessage + `</p>
                    </div>
                `;
            } finally {
                btn.disabled = false;
                btn.innerHTML = originalText;
            }
        }
        
        function escapeHtml(text) {
            if (!text) return '';
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }
    </script>
</body>
</html>

