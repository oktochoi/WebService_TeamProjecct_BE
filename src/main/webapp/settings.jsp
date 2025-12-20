<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>설정 - 노오력지수</title>
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
        <nav class="border-b border-gray-800 bg-[#161b22]">
            <div class="max-w-7xl mx-auto px-6 py-4">
                <div class="flex items-center justify-between">
                    <div class="flex items-center gap-4">
                        <a href="dashboard.jsp" class="w-9 h-9 flex items-center justify-center text-gray-400 hover:bg-gray-800 rounded-lg transition-colors cursor-pointer">
                            <i class="ri-arrow-left-line text-xl"></i>
                        </a>
                        <h1 class="text-xl font-semibold text-white">설정</h1>
                    </div>
                </div>
            </div>
        </nav>

        <div class="max-w-7xl mx-auto px-6 py-8">
            <div class="flex gap-8">
                <aside class="w-64">
                    <nav class="space-y-1">
                        <button
                            onclick="switchTab('profile')"
                            id="tab-profile"
                            class="w-full flex items-center gap-3 px-4 py-2 rounded-lg transition-colors text-left whitespace-nowrap cursor-pointer bg-gray-800 text-white"
                        >
                            <i class="ri-user-line text-lg"></i>
                            프로필
                        </button>
                        <button
                            onclick="switchTab('account')"
                            id="tab-account"
                            class="w-full flex items-center gap-3 px-4 py-2 rounded-lg transition-colors text-left whitespace-nowrap cursor-pointer text-gray-400 hover:bg-gray-800/50"
                        >
                            <i class="ri-settings-3-line text-lg"></i>
                            계정
                        </button>
                        <button
                            onclick="switchTab('notifications')"
                            id="tab-notifications"
                            class="w-full flex items-center gap-3 px-4 py-2 rounded-lg transition-colors text-left whitespace-nowrap cursor-pointer text-gray-400 hover:bg-gray-800/50"
                        >
                            <i class="ri-notification-line text-lg"></i>
                            알림
                        </button>
                        <button
                            onclick="switchTab('integrations')"
                            id="tab-integrations"
                            class="w-full flex items-center gap-3 px-4 py-2 rounded-lg transition-colors text-left whitespace-nowrap cursor-pointer text-gray-400 hover:bg-gray-800/50"
                        >
                            <i class="ri-link text-lg"></i>
                            연동
                        </button>
                    </nav>
                </aside>

                <main class="flex-1">
                    <!-- Profile Tab -->
                    <div id="content-profile" class="tab-content">
                        <div class="space-y-6">
                            <div class="p-6 rounded-lg border border-gray-800 bg-[#161b22]">
                                <h2 class="text-lg font-semibold text-white mb-6">프로필 정보</h2>
                                <div class="space-y-6">
                                    <div class="flex items-center gap-4">
                                        <div class="relative">
                                            <img 
                                                id="profileImage" 
                                                src="" 
                                                alt="프로필 사진" 
                                                class="w-20 h-20 rounded-full object-cover border-2 border-gray-700 hidden"
                                                onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';"
                                            />
                                            <div id="profileImagePlaceholder" class="w-20 h-20 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white text-2xl font-semibold">
                                                <% 
                                                    if (session != null && session.getAttribute("name") != null) {
                                                        String name = (String) session.getAttribute("name");
                                                        if (name != null && !name.isEmpty()) {
                                                            out.print(name.substring(0, 1).toUpperCase());
                                                        } else {
                                                            out.print("U");
                                                        }
                                                    } else {
                                                        out.print("U");
                                                    }
                                                %>
                                            </div>
                                        </div>
                                        <div class="flex flex-col gap-2">
                                            <label for="imageUpload" class="px-4 py-2 text-gray-300 border border-gray-700 rounded-lg hover:bg-gray-800 transition-colors whitespace-nowrap cursor-pointer text-center">
                                                <i class="ri-image-add-line"></i> 사진 변경
                                            </label>
                                            <input 
                                                type="file" 
                                                id="imageUpload" 
                                                accept="image/*" 
                                                class="hidden" 
                                                onchange="handleImageUpload(event)"
                                            />
                                            <button 
                                                onclick="removeProfileImage()" 
                                                id="removeImageBtn"
                                                class="px-4 py-2 text-red-400 border border-red-700 rounded-lg hover:bg-red-900/20 transition-colors whitespace-nowrap cursor-pointer text-sm hidden"
                                            >
                                                <i class="ri-delete-bin-line"></i> 사진 제거
                                            </button>
                                        </div>
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-300 mb-2">
                                            이름
                                        </label>
                                        <input
                                            type="text"
                                            value="최옥토"
                                            class="w-full px-4 py-2 bg-[#0d1117] border border-gray-700 rounded-lg text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                        />
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-300 mb-2">
                                            이메일
                                        </label>
                                        <input
                                            type="email"
                                            value="oktochoi@github.com"
                                            class="w-full px-4 py-2 bg-[#0d1117] border border-gray-700 rounded-lg text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                        />
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-300 mb-2">
                                            소개
                                        </label>
                                        <textarea
                                            rows="4"
                                            class="w-full px-4 py-2 bg-[#0d1117] border border-gray-700 rounded-lg text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
                                        >풀스택 개발자입니다.</textarea>
                                    </div>
                                </div>
                                <div class="flex justify-end gap-3 mt-6">
                                    <button class="px-4 py-2 text-gray-300 hover:bg-gray-800 rounded-lg transition-colors whitespace-nowrap cursor-pointer">
                                        취소
                                    </button>
                                    <button class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors whitespace-nowrap cursor-pointer">
                                        저장
                                    </button>
                                </div>
                            </div>

                            <div class="p-6 rounded-lg border border-gray-800 bg-[#161b22]">
                                <h2 class="text-lg font-semibold text-white mb-6">내 활동</h2>
                                
                                <div class="grid grid-cols-2 gap-4 mb-6">
                                    <div class="text-center p-4 rounded-lg bg-[#0d1117]">
                                        <p class="text-2xl font-bold text-white">12</p>
                                        <p class="text-sm text-gray-400">프로젝트</p>
                                    </div>
                                    <div class="text-center p-4 rounded-lg bg-[#0d1117]">
                                        <p class="text-2xl font-bold text-white">34</p>
                                        <p class="text-sm text-gray-400">받은 리뷰</p>
                                    </div>
                                </div>

                                <div class="p-4 rounded-lg bg-yellow-900/20 border border-yellow-800">
                                    <div class="flex items-center justify-center gap-2 mb-2">
                                        <i class="ri-star-fill text-yellow-500 text-xl"></i>
                                        <span class="text-2xl font-bold text-white">4.5</span>
                                    </div>
                                    <p class="text-sm text-center text-gray-400">평균 평점</p>
                                </div>

                                <div class="flex gap-2 mt-6 border-b border-gray-800">
                                    <button
                                        onclick="switchProfileSubTab('overview')"
                                        id="profile-subtab-overview"
                                        class="px-4 py-2 font-medium transition-colors border-b-2 border-blue-500 text-white whitespace-nowrap cursor-pointer"
                                    >
                                        개요
                                    </button>
                                    <button
                                        onclick="switchProfileSubTab('reviews')"
                                        id="profile-subtab-reviews"
                                        class="px-4 py-2 font-medium transition-colors border-b-2 border-transparent text-gray-400 hover:text-white whitespace-nowrap cursor-pointer"
                                    >
                                        받은 리뷰
                                    </button>
                                    <button
                                        onclick="switchProfileSubTab('projects')"
                                        id="profile-subtab-projects"
                                        class="px-4 py-2 font-medium transition-colors border-b-2 border-transparent text-gray-400 hover:text-white whitespace-nowrap cursor-pointer"
                                    >
                                        프로젝트 이력
                                    </button>
                                </div>

                                <div class="mt-6">
                                    <div id="profile-content-overview" class="profile-sub-content">
                                        <div class="space-y-4">
                                            <div class="grid grid-cols-2 gap-4">
                                                <div class="p-4 rounded-lg border border-gray-800 bg-[#161b22]">
                                                    <div class="flex items-center gap-3">
                                                        <div class="w-10 h-10 flex items-center justify-center rounded-lg bg-blue-900/30">
                                                            <i class="ri-git-commit-line text-xl text-blue-400"></i>
                                                        </div>
                                                        <div>
                                                            <p class="text-xl font-bold text-white">1247</p>
                                                            <p class="text-xs text-gray-400">총 커밋</p>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="p-4 rounded-lg border border-gray-800 bg-[#161b22]">
                                                    <div class="flex items-center gap-3">
                                                        <div class="w-10 h-10 flex items-center justify-center rounded-lg bg-purple-900/30">
                                                            <i class="ri-git-pull-request-line text-xl text-purple-400"></i>
                                                        </div>
                                                        <div>
                                                            <p class="text-xl font-bold text-white">156</p>
                                                            <p class="text-xs text-gray-400">Pull Requests</p>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="p-4 rounded-lg border border-gray-800 bg-[#161b22]">
                                                    <div class="flex items-center gap-3">
                                                        <div class="w-10 h-10 flex items-center justify-center rounded-lg bg-green-900/30">
                                                            <i class="ri-error-warning-line text-xl text-green-400"></i>
                                                        </div>
                                                        <div>
                                                            <p class="text-xl font-bold text-white">89</p>
                                                            <p class="text-xs text-gray-400">이슈 해결</p>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="p-4 rounded-lg border border-gray-800 bg-[#161b22]">
                                                    <div class="flex items-center gap-3">
                                                        <div class="w-10 h-10 flex items-center justify-center rounded-lg bg-orange-900/30">
                                                            <i class="ri-chat-check-line text-xl text-orange-400"></i>
                                                        </div>
                                                        <div>
                                                            <p class="text-xl font-bold text-white">234</p>
                                                            <p class="text-xs text-gray-400">코드 리뷰</p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div id="profile-content-reviews" class="profile-sub-content hidden">
                                        <div class="space-y-4">
                                            <div class="p-4 rounded-lg border border-gray-800 bg-[#161b22]">
                                                <div class="flex items-start justify-between mb-3">
                                                    <div class="flex items-center gap-3">
                                                        <div class="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-semibold text-sm">
                                                            DJ
                                                        </div>
                                                        <div>
                                                            <h4 class="font-semibold text-white text-sm">devjohn</h4>
                                                            <a href="project-detail.jsp?id=1" class="text-xs text-blue-400 hover:underline cursor-pointer">
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
                                                        <span class="text-xs text-gray-400">2024-01-20</span>
                                                    </div>
                                                </div>
                                                <p class="text-sm text-gray-300 leading-relaxed">프로젝트 리더십이 뛰어나고 코드 품질이 매우 높습니다. 팀원들과의 소통도 원활하게 잘 이루어졌습니다.</p>
                                            </div>
                                        </div>
                                    </div>

                                    <div id="profile-content-projects" class="profile-sub-content hidden">
                                        <div class="space-y-3">
                                            <a href="project-detail.jsp?id=1" class="block p-4 rounded-lg border border-gray-800 bg-[#161b22] hover:border-gray-700 transition-colors cursor-pointer">
                                                <div class="flex items-start justify-between mb-2">
                                                    <div>
                                                        <h4 class="font-semibold text-white text-sm mb-1">
                                                            AI 챗봇 프로젝트
                                                        </h4>
                                                        <p class="text-xs text-gray-400">2024-01 ~ 진행중</p>
                                                    </div>
                                                    <span class="px-2 py-1 text-xs font-medium rounded-full whitespace-nowrap bg-green-900/30 text-green-400">
                                                        완료
                                                    </span>
                                                </div>
                                                <div class="flex items-center justify-between">
                                                    <span class="text-xs text-gray-400">Owner</span>
                                                    <div class="flex items-center gap-2">
                                                        <span class="text-xs text-gray-400">기여도</span>
                                                        <span class="text-sm font-bold text-white">95</span>
                                                    </div>
                                                </div>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Account Tab -->
                    <div id="content-account" class="tab-content hidden">
                        <div class="space-y-6">
                            <div class="p-6 rounded-lg border border-gray-800 bg-[#161b22]">
                                <h2 class="text-lg font-semibold text-white mb-6">계정 설정</h2>
                                <div class="space-y-6">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-300 mb-2">
                                            현재 비밀번호
                                        </label>
                                        <input
                                            type="password"
                                            class="w-full px-4 py-2 bg-[#0d1117] border border-gray-700 rounded-lg text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                        />
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-300 mb-2">
                                            새 비밀번호
                                        </label>
                                        <input
                                            type="password"
                                            class="w-full px-4 py-2 bg-[#0d1117] border border-gray-700 rounded-lg text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                        />
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-300 mb-2">
                                            새 비밀번호 확인
                                        </label>
                                        <input
                                            type="password"
                                            class="w-full px-4 py-2 bg-[#0d1117] border border-gray-700 rounded-lg text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                        />
                                    </div>
                                </div>
                                <div class="flex justify-end mt-6">
                                    <button class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors whitespace-nowrap cursor-pointer">
                                        비밀번호 변경
                                    </button>
                                </div>
                            </div>

                            <div class="p-6 rounded-lg border border-red-800 bg-red-900/20">
                                <h2 class="text-lg font-semibold text-red-300 mb-2">계정 삭제</h2>
                                <p class="text-sm text-red-400 mb-4">
                                    계정을 삭제하면 모든 데이터가 영구적으로 삭제됩니다.
                                </p>
                                <button class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors whitespace-nowrap cursor-pointer">
                                    계정 삭제
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Notifications Tab -->
                    <div id="content-notifications" class="tab-content hidden">
                        <div class="p-6 rounded-lg border border-gray-800 bg-[#161b22]">
                            <h2 class="text-lg font-semibold text-white mb-6">알림 설정</h2>
                            <div class="space-y-4">
                                <div class="flex items-center justify-between p-4 rounded-lg border border-gray-800">
                                    <div>
                                        <p class="font-medium text-white">새 프로젝트 생성 알림</p>
                                        <p class="text-sm text-gray-400">팀원이 새 프로젝트를 생성할 때</p>
                                    </div>
                                    <label class="relative inline-flex items-center cursor-pointer">
                                        <input type="checkbox" class="sr-only peer" checked />
                                        <div class="w-11 h-6 bg-gray-700 peer-focus:outline-none peer-focus:ring-2 peer-focus:ring-blue-500 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"></div>
                                    </label>
                                </div>
                                <div class="flex items-center justify-between p-4 rounded-lg border border-gray-800">
                                    <div>
                                        <p class="font-medium text-white">리뷰 요청 알림</p>
                                        <p class="text-sm text-gray-400">팀원이 리뷰를 요청할 때</p>
                                    </div>
                                    <label class="relative inline-flex items-center cursor-pointer">
                                        <input type="checkbox" class="sr-only peer" checked />
                                        <div class="w-11 h-6 bg-gray-700 peer-focus:outline-none peer-focus:ring-2 peer-focus:ring-blue-500 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"></div>
                                    </label>
                                </div>
                                <div class="flex items-center justify-between p-4 rounded-lg border border-gray-800">
                                    <div>
                                        <p class="font-medium text-white">AI 분석 완료 알림</p>
                                        <p class="text-sm text-gray-400">AI 분석이 완료되었을 때</p>
                                    </div>
                                    <label class="relative inline-flex items-center cursor-pointer">
                                        <input type="checkbox" class="sr-only peer" checked />
                                        <div class="w-11 h-6 bg-gray-700 peer-focus:outline-none peer-focus:ring-2 peer-focus:ring-blue-500 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"></div>
                                    </label>
                                </div>
                                <div class="flex items-center justify-between p-4 rounded-lg border border-gray-800">
                                    <div>
                                        <p class="font-medium text-white">주간 리포트</p>
                                        <p class="text-sm text-gray-400">매주 월요일 프로젝트 요약 리포트</p>
                                    </div>
                                    <label class="relative inline-flex items-center cursor-pointer">
                                        <input type="checkbox" class="sr-only peer" checked />
                                        <div class="w-11 h-6 bg-gray-700 peer-focus:outline-none peer-focus:ring-2 peer-focus:ring-blue-500 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"></div>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Integrations Tab -->
                    <div id="content-integrations" class="tab-content hidden">
                        <div class="space-y-6">
                            <div class="p-6 rounded-lg border border-gray-800 bg-[#161b22]">
                                <h2 class="text-lg font-semibold text-white mb-6">연동된 서비스</h2>
                                <div class="space-y-4">
                                    <div class="flex items-center justify-between p-4 rounded-lg border border-gray-800">
                                        <div class="flex items-center gap-3">
                                            <i class="ri-github-fill text-3xl text-white"></i>
                                            <div>
                                                <p class="font-medium text-white">GitHub</p>
                                                <p class="text-sm text-gray-400">oktochoi@github.com</p>
                                            </div>
                                        </div>
                                        <span class="px-3 py-1 text-sm bg-green-900/30 text-green-400 rounded-full whitespace-nowrap">
                                            연동됨
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>
    </div>

    <script>
        let currentTab = 'profile';
        let currentProfileSubTab = 'overview';

        function switchTab(tab) {
            // Hide all tab contents
            document.querySelectorAll('.tab-content').forEach(content => {
                content.classList.add('hidden');
            });
            document.querySelectorAll('[id^="tab-"]').forEach(btn => {
                btn.classList.remove('bg-gray-800', 'text-white');
                btn.classList.add('text-gray-400');
            });

            // Show selected tab
            document.getElementById('content-' + tab).classList.remove('hidden');
            const tabBtn = document.getElementById('tab-' + tab);
            tabBtn.classList.add('bg-gray-800', 'text-white');
            tabBtn.classList.remove('text-gray-400');
            currentTab = tab;
        }

        function switchProfileSubTab(tab) {
            document.querySelectorAll('.profile-sub-content').forEach(content => {
                content.classList.add('hidden');
            });
            document.querySelectorAll('[id^="profile-subtab-"]').forEach(btn => {
                btn.classList.remove('border-blue-500', 'text-white');
                btn.classList.add('border-transparent', 'text-gray-400');
            });

            document.getElementById('profile-content-' + tab).classList.remove('hidden');
            const tabBtn = document.getElementById('profile-subtab-' + tab);
            tabBtn.classList.add('border-blue-500', 'text-white');
            tabBtn.classList.remove('border-transparent', 'text-gray-400');
            currentProfileSubTab = tab;
        }

        // 프로필 사진 업로드
        async function handleImageUpload(event) {
            const file = event.target.files[0];
            if (!file) return;

            // 파일 크기 검증 (5MB 제한)
            if (file.size > 5 * 1024 * 1024) {
                alert('파일 크기는 5MB 이하여야 합니다.');
                return;
            }

            // 이미지 파일인지 확인
            if (!file.type.startsWith('image/')) {
                alert('이미지 파일만 업로드할 수 있습니다.');
                return;
            }

            const formData = new FormData();
            formData.append('image', file);

            try {
                const response = await fetch('<%= request.getContextPath() %>/api/profile/upload-image', {
                    method: 'POST',
                    body: formData,
                    credentials: 'same-origin'
                });

                if (!response.ok) {
                    const error = await response.json();
                    throw new Error(error.error || '이미지 업로드에 실패했습니다.');
                }

                const result = await response.json();
                
                // 이미지 표시
                const profileImage = document.getElementById('profileImage');
                const placeholder = document.getElementById('profileImagePlaceholder');
                const removeBtn = document.getElementById('removeImageBtn');
                
                if (result.imageUrl) {
                    profileImage.src = result.imageUrl;
                    profileImage.style.display = 'block';
                    placeholder.style.display = 'none';
                    removeBtn.classList.remove('hidden');
                }

                // 성공 메시지
                const successMsg = document.createElement('div');
                successMsg.className = 'fixed top-4 right-4 bg-green-600 text-white px-6 py-3 rounded-lg shadow-lg z-50';
                successMsg.innerHTML = '<i class="ri-check-line"></i> 프로필 사진이 업로드되었습니다.';
                document.body.appendChild(successMsg);
                
                setTimeout(() => {
                    successMsg.remove();
                }, 3000);
            } catch (error) {
                console.error('이미지 업로드 오류:', error);
                alert('이미지 업로드 중 오류가 발생했습니다: ' + error.message);
            }
        }

        // 프로필 사진 제거
        async function removeProfileImage() {
            if (!confirm('프로필 사진을 제거하시겠습니까?')) return;

            try {
                const response = await fetch('<%= request.getContextPath() %>/api/profile/remove-image', {
                    method: 'POST',
                    credentials: 'same-origin'
                });

                if (!response.ok) {
                    throw new Error('이미지 제거에 실패했습니다.');
                }

                // 이미지 숨기기
                const profileImage = document.getElementById('profileImage');
                const placeholder = document.getElementById('profileImagePlaceholder');
                const removeBtn = document.getElementById('removeImageBtn');
                
                profileImage.style.display = 'none';
                placeholder.style.display = 'flex';
                removeBtn.classList.add('hidden');

                // 성공 메시지
                const successMsg = document.createElement('div');
                successMsg.className = 'fixed top-4 right-4 bg-green-600 text-white px-6 py-3 rounded-lg shadow-lg z-50';
                successMsg.innerHTML = '<i class="ri-check-line"></i> 프로필 사진이 제거되었습니다.';
                document.body.appendChild(successMsg);
                
                setTimeout(() => {
                    successMsg.remove();
                }, 3000);
            } catch (error) {
                console.error('이미지 제거 오류:', error);
                alert('이미지 제거 중 오류가 발생했습니다: ' + error.message);
            }
        }

        // 페이지 로드 시 프로필 사진 불러오기
        async function loadProfileImage() {
            try {
                const response = await fetch('<%= request.getContextPath() %>/api/profile/image', {
                    credentials: 'same-origin'
                });

                if (response.ok) {
                    const result = await response.json();
                    if (result.imageUrl) {
                        const profileImage = document.getElementById('profileImage');
                        const placeholder = document.getElementById('profileImagePlaceholder');
                        const removeBtn = document.getElementById('removeImageBtn');
                        
                        profileImage.src = result.imageUrl;
                        profileImage.style.display = 'block';
                        placeholder.style.display = 'none';
                        removeBtn.classList.remove('hidden');
                    }
                }
            } catch (error) {
                console.error('프로필 사진 로드 오류:', error);
            }
        }

        // 페이지 로드 시 실행
        document.addEventListener('DOMContentLoaded', function() {
            loadProfileImage();
        });
    </script>
</body>
</html>

