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
                                            id="profileName"
                                            value="<%= session != null && session.getAttribute("name") != null ? session.getAttribute("name") : (session != null && session.getAttribute("username") != null ? session.getAttribute("username") : "") %>"
                                            class="w-full px-4 py-2 bg-[#0d1117] border border-gray-700 rounded-lg text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                        />
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-300 mb-2">
                                            이메일
                                        </label>
                                        <input
                                            type="email"
                                            id="profileEmail"
                                            value="<%= session != null && session.getAttribute("email") != null ? session.getAttribute("email") : "" %>"
                                            class="w-full px-4 py-2 bg-[#0d1117] border border-gray-700 rounded-lg text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                        />
                                    </div>
                                </div>
                                <div class="flex justify-end gap-3 mt-6">
                                    <button onclick="window.location.href='dashboard.jsp'" class="px-4 py-2 text-gray-300 hover:bg-gray-800 rounded-lg transition-colors whitespace-nowrap cursor-pointer">
                                        취소
                                    </button>
                                    <button onclick="saveProfile()" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors whitespace-nowrap cursor-pointer">
                                        저장
                                    </button>
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
                                                <p class="text-sm text-gray-400">
                                                    <%= session != null && session.getAttribute("email") != null ? session.getAttribute("email") : (session != null && session.getAttribute("username") != null ? session.getAttribute("username") + "@github.com" : "") %>
                                                </p>
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
                    const imageUrl = '<%= request.getContextPath() %>' + result.imageUrl;
                    profileImage.src = imageUrl;
                    profileImage.onload = function() {
                        profileImage.style.display = 'block';
                        placeholder.style.display = 'none';
                        removeBtn.classList.remove('hidden');
                    };
                    profileImage.onerror = function() {
                        console.error('이미지 로드 실패:', imageUrl);
                        profileImage.style.display = 'none';
                        placeholder.style.display = 'flex';
                    };
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
                // 먼저 세션에서 확인
                <% 
                    String sessionImageUrl = null;
                    if (session != null) {
                        sessionImageUrl = (String) session.getAttribute("profileImageUrl");
                    }
                %>
                <% if (sessionImageUrl != null) { %>
                    const sessionImageUrl = '<%= sessionImageUrl %>';
                    const profileImage = document.getElementById('profileImage');
                    const placeholder = document.getElementById('profileImagePlaceholder');
                    const removeBtn = document.getElementById('removeImageBtn');
                    
                    profileImage.src = '<%= request.getContextPath() %>' + sessionImageUrl;
                    profileImage.onload = function() {
                        profileImage.style.display = 'block';
                        placeholder.style.display = 'none';
                        removeBtn.classList.remove('hidden');
                    };
                    profileImage.onerror = function() {
                        profileImage.style.display = 'none';
                        placeholder.style.display = 'flex';
                        removeBtn.classList.add('hidden');
                    };
                <% } %>
                
                // API에서 최신 정보 가져오기
                const response = await fetch('<%= request.getContextPath() %>/api/profile/image', {
                    credentials: 'same-origin'
                });

                if (response.ok) {
                    const result = await response.json();
                    if (result.imageUrl) {
                        const profileImage = document.getElementById('profileImage');
                        const placeholder = document.getElementById('profileImagePlaceholder');
                        const removeBtn = document.getElementById('removeImageBtn');
                        
                        const imageUrl = '<%= request.getContextPath() %>' + result.imageUrl;
                        profileImage.src = imageUrl;
                        profileImage.onload = function() {
                            profileImage.style.display = 'block';
                            placeholder.style.display = 'none';
                            removeBtn.classList.remove('hidden');
                        };
                        profileImage.onerror = function() {
                            profileImage.style.display = 'none';
                            placeholder.style.display = 'flex';
                            removeBtn.classList.add('hidden');
                        };
                    }
                }
            } catch (error) {
                console.error('프로필 사진 로드 오류:', error);
            }
        }

        // 프로필 저장
        async function saveProfile() {
            const name = document.getElementById('profileName').value;
            const email = document.getElementById('profileEmail').value;
            
            if (!name || !email) {
                alert('이름과 이메일을 모두 입력해주세요.');
                return;
            }
            
            try {
                const formData = new FormData();
                formData.append('name', name);
                formData.append('email', email);
                
                const response = await fetch('<%= request.getContextPath() %>/api/profile/save', {
                    method: 'POST',
                    body: formData,
                    credentials: 'same-origin'
                });
                
                if (!response.ok) {
                    const error = await response.json();
                    throw new Error(error.error || '프로필 저장에 실패했습니다.');
                }
                
                const result = await response.json();
                
                // 성공 메시지
                const successMsg = document.createElement('div');
                successMsg.className = 'fixed top-4 right-4 bg-green-600 text-white px-6 py-3 rounded-lg shadow-lg z-50';
                successMsg.innerHTML = '<i class="ri-check-line"></i> 프로필이 저장되었습니다.';
                document.body.appendChild(successMsg);
                
                setTimeout(() => {
                    successMsg.remove();
                    // 대시보드로 이동
                    window.location.href = 'dashboard.jsp';
                }, 1000);
            } catch (error) {
                console.error('프로필 저장 오류:', error);
                alert('프로필 저장 중 오류가 발생했습니다: ' + error.message);
            }
        }

        // 페이지 로드 시 실행
        document.addEventListener('DOMContentLoaded', function() {
            loadProfileImage();
        });
    </script>
</body>
</html>

