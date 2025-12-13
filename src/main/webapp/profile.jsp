<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String username = request.getParameter("username");
    if (username == null) username = "oktochoi";
    
    String fullName = "최옥토";
    String avatar = username.substring(0, 2).toUpperCase();
    if (username.equals("devjohn")) {
        fullName = "존 개발자";
        avatar = "DJ";
    } else if (username.equals("codemaster")) {
        fullName = "코드마스터";
        avatar = "CM";
    } else if (username.equals("techguru")) {
        fullName = "테크구루";
        avatar = "TG";
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>프로필 - <%= fullName %> - 노오력지수</title>
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
    <div class="min-h-screen bg-[#0d1117]">
        <nav class="border-b border-gray-800 bg-[#161b22] sticky top-0 z-10">
            <div class="max-w-7xl mx-auto px-6 py-4">
                <div class="flex items-center justify-between">
                    <div class="flex items-center gap-4">
                        <a href="dashboard.jsp" class="w-9 h-9 flex items-center justify-center text-gray-400 hover:bg-gray-800 rounded-lg transition-colors cursor-pointer">
                            <i class="ri-arrow-left-line text-xl"></i>
                        </a>
                        <h1 class="text-xl font-semibold text-white">프로필</h1>
                    </div>
                </div>
            </div>
        </nav>

        <div class="max-w-7xl mx-auto px-6 py-8">
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
                <div class="lg:col-span-1">
                    <div class="p-6 rounded-lg border border-gray-800 bg-[#161b22] sticky top-24">
                        <div class="flex flex-col items-center text-center mb-6">
                            <div class="w-24 h-24 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-bold text-3xl mb-4">
                                <%= avatar %>
                            </div>
                            <h2 class="text-2xl font-bold text-white mb-1">
                                <%= fullName %>
                            </h2>
                            <p class="text-gray-400 mb-4">@<%= username %></p>
                            <p class="text-sm text-gray-400 mb-6">풀스택 개발자 | React & Node.js 전문</p>
                        </div>

                        <div class="space-y-3 mb-6">
                            <div class="flex items-center gap-3 text-sm text-gray-400">
                                <i class="ri-mail-line w-5 h-5 flex items-center justify-center"></i>
                                <span><%= username %>@example.com</span>
                            </div>
                            <div class="flex items-center gap-3 text-sm text-gray-400">
                                <i class="ri-github-fill w-5 h-5 flex items-center justify-center"></i>
                                <span>github.com/<%= username %></span>
                            </div>
                            <div class="flex items-center gap-3 text-sm text-gray-400">
                                <i class="ri-calendar-line w-5 h-5 flex items-center justify-center"></i>
                                <span>2023-05-15 가입</span>
                            </div>
                        </div>

                        <div class="grid grid-cols-2 gap-4 pt-6 border-t border-gray-800">
                            <div class="text-center">
                                <p class="text-2xl font-bold text-white">12</p>
                                <p class="text-sm text-gray-400">프로젝트</p>
                            </div>
                            <div class="text-center">
                                <p class="text-2xl font-bold text-white">34</p>
                                <p class="text-sm text-gray-400">받은 리뷰</p>
                            </div>
                        </div>

                        <div class="mt-6 p-4 rounded-lg bg-yellow-900/20 border border-yellow-800">
                            <div class="flex items-center justify-center gap-2 mb-2">
                                <i class="ri-star-fill text-yellow-500 text-xl"></i>
                                <span class="text-2xl font-bold text-white">4.5</span>
                            </div>
                            <p class="text-sm text-center text-gray-400">평균 평점</p>
                        </div>
                    </div>
                </div>

                <div class="lg:col-span-2">
                    <div class="flex gap-2 mb-6 border-b border-gray-800">
                        <button
                            onclick="switchTab('overview')"
                            id="tab-overview"
                            class="px-4 py-2 font-medium transition-colors flex items-center gap-2 border-b-2 border-blue-500 text-white whitespace-nowrap cursor-pointer"
                        >
                            <i class="ri-dashboard-line"></i>
                            개요
                        </button>
                        <button
                            onclick="switchTab('reviews')"
                            id="tab-reviews"
                            class="px-4 py-2 font-medium transition-colors flex items-center gap-2 border-b-2 border-transparent text-gray-400 hover:text-white whitespace-nowrap cursor-pointer"
                        >
                            <i class="ri-chat-3-line"></i>
                            받은 리뷰
                        </button>
                        <button
                            onclick="switchTab('projects')"
                            id="tab-projects"
                            class="px-4 py-2 font-medium transition-colors flex items-center gap-2 border-b-2 border-transparent text-gray-400 hover:text-white whitespace-nowrap cursor-pointer"
                        >
                            <i class="ri-folder-line"></i>
                            프로젝트 이력
                        </button>
                    </div>

                    <!-- Overview Tab -->
                    <div id="content-overview" class="tab-content">
                        <div class="space-y-6">
                            <div class="grid grid-cols-2 gap-4">
                                <div class="p-6 rounded-lg border border-gray-800 bg-[#161b22]">
                                    <div class="flex items-center gap-3">
                                        <div class="w-12 h-12 flex items-center justify-center rounded-lg bg-blue-900/30">
                                            <i class="ri-git-commit-line text-2xl text-blue-400"></i>
                                        </div>
                                        <div>
                                            <p class="text-2xl font-bold text-white">1247</p>
                                            <p class="text-sm text-gray-400">총 커밋</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="p-6 rounded-lg border border-gray-800 bg-[#161b22]">
                                    <div class="flex items-center gap-3">
                                        <div class="w-12 h-12 flex items-center justify-center rounded-lg bg-purple-900/30">
                                            <i class="ri-git-pull-request-line text-2xl text-purple-400"></i>
                                        </div>
                                        <div>
                                            <p class="text-2xl font-bold text-white">156</p>
                                            <p class="text-sm text-gray-400">Pull Requests</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="p-6 rounded-lg border border-gray-800 bg-[#161b22]">
                                    <div class="flex items-center gap-3">
                                        <div class="w-12 h-12 flex items-center justify-center rounded-lg bg-green-900/30">
                                            <i class="ri-error-warning-line text-2xl text-green-400"></i>
                                        </div>
                                        <div>
                                            <p class="text-2xl font-bold text-white">89</p>
                                            <p class="text-sm text-gray-400">이슈 해결</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="p-6 rounded-lg border border-gray-800 bg-[#161b22]">
                                    <div class="flex items-center gap-3">
                                        <div class="w-12 h-12 flex items-center justify-center rounded-lg bg-orange-900/30">
                                            <i class="ri-chat-check-line text-2xl text-orange-400"></i>
                                        </div>
                                        <div>
                                            <p class="text-2xl font-bold text-white">234</p>
                                            <p class="text-sm text-gray-400">코드 리뷰</p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="p-6 rounded-lg border border-gray-800 bg-[#161b22]">
                                <h3 class="text-lg font-semibold text-white mb-4">
                                    최근 활동
                                </h3>
                                <div class="space-y-4">
                                    <div class="flex items-start gap-3 p-4 rounded-lg bg-[#0d1117]">
                                        <div class="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-semibold flex-shrink-0">
                                            DJ
                                        </div>
                                        <div class="flex-1 min-w-0">
                                            <div class="flex items-center gap-2 mb-1">
                                                <span class="font-medium text-white">devjohn</span>
                                                <span class="text-sm text-gray-400">님이 리뷰를 남겼습니다</span>
                                            </div>
                                            <a href="project-detail.jsp?id=1" class="text-sm text-blue-400 hover:underline cursor-pointer">
                                                AI 챗봇 프로젝트
                                            </a>
                                            <p class="text-sm text-gray-400 mt-1">2024-01-20</p>
                                        </div>
                                    </div>
                                    <div class="flex items-start gap-3 p-4 rounded-lg bg-[#0d1117]">
                                        <div class="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-semibold flex-shrink-0">
                                            CM
                                        </div>
                                        <div class="flex-1 min-w-0">
                                            <div class="flex items-center gap-2 mb-1">
                                                <span class="font-medium text-white">codemaster</span>
                                                <span class="text-sm text-gray-400">님이 리뷰를 남겼습니다</span>
                                            </div>
                                            <a href="project-detail.jsp?id=1" class="text-sm text-blue-400 hover:underline cursor-pointer">
                                                AI 챗봇 프로젝트
                                            </a>
                                            <p class="text-sm text-gray-400 mt-1">2024-01-20</p>
                                        </div>
                                    </div>
                                    <div class="flex items-start gap-3 p-4 rounded-lg bg-[#0d1117]">
                                        <div class="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-semibold flex-shrink-0">
                                            TG
                                        </div>
                                        <div class="flex-1 min-w-0">
                                            <div class="flex items-center gap-2 mb-1">
                                                <span class="font-medium text-white">techguru</span>
                                                <span class="text-sm text-gray-400">님이 리뷰를 남겼습니다</span>
                                            </div>
                                            <a href="project-detail.jsp?id=2" class="text-sm text-blue-400 hover:underline cursor-pointer">
                                                E-커머스 플랫폼
                                            </a>
                                            <p class="text-sm text-gray-400 mt-1">2024-01-15</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Reviews Tab -->
                    <div id="content-reviews" class="tab-content hidden">
                        <div class="space-y-4">
                            <div class="p-6 rounded-lg border border-gray-800 bg-[#161b22]">
                                <div class="flex items-start justify-between mb-4">
                                    <div class="flex items-center gap-3">
                                        <div class="w-12 h-12 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-semibold">
                                            DJ
                                        </div>
                                        <div>
                                            <h4 class="font-semibold text-white">devjohn</h4>
                                            <a href="project-detail.jsp?id=1" class="text-sm text-blue-400 hover:underline cursor-pointer">
                                                AI 챗봇 프로젝트
                                            </a>
                                        </div>
                                    </div>
                                    <div class="flex items-center gap-2">
                                        <div class="flex gap-1">
                                            <i class="text-sm ri-star-fill text-yellow-500"></i>
                                            <i class="text-sm ri-star-fill text-yellow-500"></i>
                                            <i class="text-sm ri-star-fill text-yellow-500"></i>
                                            <i class="text-sm ri-star-fill text-yellow-500"></i>
                                            <i class="text-sm ri-star-fill text-yellow-500"></i>
                                        </div>
                                        <span class="text-sm text-gray-400">2024-01-20</span>
                                    </div>
                                </div>
                                <p class="text-gray-300 leading-relaxed">프로젝트 리더십이 뛰어나고 코드 품질이 매우 높습니다. 팀원들과의 소통도 원활하게 잘 이루어졌습니다.</p>
                            </div>
                            <div class="p-6 rounded-lg border border-gray-800 bg-[#161b22]">
                                <div class="flex items-start justify-between mb-4">
                                    <div class="flex items-center gap-3">
                                        <div class="w-12 h-12 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-semibold">
                                            CM
                                        </div>
                                        <div>
                                            <h4 class="font-semibold text-white">codemaster</h4>
                                            <a href="project-detail.jsp?id=1" class="text-sm text-blue-400 hover:underline cursor-pointer">
                                                AI 챗봇 프로젝트
                                            </a>
                                        </div>
                                    </div>
                                    <div class="flex items-center gap-2">
                                        <div class="flex gap-1">
                                            <i class="text-sm ri-star-fill text-yellow-500"></i>
                                            <i class="text-sm ri-star-fill text-yellow-500"></i>
                                            <i class="text-sm ri-star-fill text-yellow-500"></i>
                                            <i class="text-sm ri-star-fill text-yellow-500"></i>
                                            <i class="text-sm ri-star-fill text-yellow-500"></i>
                                        </div>
                                        <span class="text-sm text-gray-400">2024-01-20</span>
                                    </div>
                                </div>
                                <p class="text-gray-300 leading-relaxed">코드 리뷰를 통해 많이 배웠습니다. 항상 친절하게 설명해주셔서 감사합니다.</p>
                            </div>
                        </div>
                    </div>

                    <!-- Projects Tab -->
                    <div id="content-projects" class="tab-content hidden">
                        <div class="space-y-4">
                            <a href="project-detail.jsp?id=1" class="block p-6 rounded-lg border border-gray-800 bg-[#161b22] hover:border-gray-700 transition-colors cursor-pointer">
                                <div class="flex items-start justify-between mb-3">
                                    <div>
                                        <h4 class="text-lg font-semibold text-white mb-1">
                                            AI 챗봇 프로젝트
                                        </h4>
                                        <p class="text-sm text-gray-400">2024-01-15</p>
                                    </div>
                                    <span class="px-2 py-1 text-xs font-medium rounded-full whitespace-nowrap bg-green-900/30 text-green-400">
                                        완료
                                    </span>
                                </div>
                                <div class="flex items-center justify-between">
                                    <span class="text-sm text-gray-400">Owner</span>
                                    <div class="flex items-center gap-2">
                                        <span class="text-sm text-gray-400">기여도</span>
                                        <span class="text-lg font-bold text-white">95</span>
                                    </div>
                                </div>
                            </a>
                            <a href="project-detail.jsp?id=2" class="block p-6 rounded-lg border border-gray-800 bg-[#161b22] hover:border-gray-700 transition-colors cursor-pointer">
                                <div class="flex items-start justify-between mb-3">
                                    <div>
                                        <h4 class="text-lg font-semibold text-white mb-1">
                                            이커머스 플랫폼
                                        </h4>
                                        <p class="text-sm text-gray-400">2024-02-20</p>
                                    </div>
                                    <span class="px-2 py-1 text-xs font-medium rounded-full whitespace-nowrap bg-green-900/30 text-green-400">
                                        완료
                                    </span>
                                </div>
                                <div class="flex items-center justify-between">
                                    <span class="text-sm text-gray-400">Contributor</span>
                                    <div class="flex items-center gap-2">
                                        <span class="text-sm text-gray-400">기여도</span>
                                        <span class="text-lg font-bold text-white">88</span>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        let currentTab = 'overview';

        function switchTab(tab) {
            // Hide all tab contents
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
    </script>
</body>
</html>

