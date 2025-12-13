<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // 서버 측 로그
    System.out.println("[dashboard.jsp] 페이지 로드 시작");
    System.out.println("[dashboard.jsp] 세션 존재: " + (session != null));
    if (session != null) {
        System.out.println("[dashboard.jsp] authenticated: " + session.getAttribute("authenticated"));
        System.out.println("[dashboard.jsp] username: " + session.getAttribute("username"));
    }
    System.out.println("[dashboard.jsp] 요청 URI: " + request.getRequestURI());
    System.out.println("[dashboard.jsp] 컨텍스트 경로: " + request.getContextPath());
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>대시보드 - 노오력지수</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            background-color: #0d1117;
            color: #e5e7eb;
        }
    </style>
    <script>
        // 클라이언트 측 로그 - 페이지 로드 시작
        console.log('[dashboard.jsp] 스크립트 로드 시작');
        console.log('[dashboard.jsp] 현재 URL:', window.location.href);
        console.log('[dashboard.jsp] document.readyState:', document.readyState);
    </script>
</head>
<body>
    <script>
        console.log('[dashboard.jsp] body 태그 시작');
        console.log('[dashboard.jsp] mainContainer 요소 찾기 시작');
    </script>
    <div class="flex min-h-screen bg-[#0d1117]" id="mainContainer">
        <!-- Sidebar 직접 포함 -->
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
                    <a href="dashboard.jsp" class="flex items-center gap-3 px-4 py-3 rounded-lg mb-1 transition-colors cursor-pointer bg-blue-600 text-white">
                        <i class="ri-dashboard-line text-xl"></i>
                        <span>대시보드</span>
                    </a>
                    <a href="dashboard.jsp" class="flex items-center gap-3 px-4 py-3 rounded-lg mb-1 transition-colors cursor-pointer text-gray-400 hover:bg-gray-800 hover:text-white">
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
                    <div class="flex items-center justify-between mb-4">
                        <h1 class="text-2xl font-bold text-white">대시보드</h1>
                        <div class="flex items-center gap-3">
                            <a href="settings.jsp" class="w-9 h-9 flex items-center justify-center rounded-lg hover:bg-gray-800 transition-colors cursor-pointer">
                                <i class="ri-settings-3-line text-xl text-gray-300"></i>
                            </a>
                        </div>
                    </div>

                    <div class="grid grid-cols-3 gap-4">
                        <div class="p-3 bg-[#0d1117] border border-gray-800 rounded-lg">
                            <div class="flex items-center gap-2 mb-1">
                                <i class="ri-folder-line text-blue-500"></i>
                                <span class="text-xs text-gray-400">총 프로젝트</span>
                            </div>
                            <p class="text-xl font-bold text-white" id="totalProjects">0</p>
                        </div>

                        <div class="p-3 bg-[#0d1117] border border-gray-800 rounded-lg">
                            <div class="flex items-center gap-2 mb-1">
                                <i class="ri-bar-chart-line text-green-500"></i>
                                <span class="text-xs text-gray-400">평균 기여도</span>
                            </div>
                            <p class="text-xl font-bold text-white" id="avgContribution">0</p>
                        </div>

                        <div class="p-3 bg-[#0d1117] border border-gray-800 rounded-lg">
                            <div class="flex items-center gap-2 mb-1">
                                <i class="ri-team-line text-purple-500"></i>
                                <span class="text-xs text-gray-400">총 팀원</span>
                            </div>
                            <p class="text-xl font-bold text-white" id="totalMembers">0</p>
                        </div>
                    </div>
                </div>
            </nav>

            <div class="p-8">
                <div class="mb-8">
                    <div class="flex items-center justify-between mb-6">
                        <div>
                            <h2 class="text-xl font-semibold text-white mb-1">내 프로젝트</h2>
                            <p class="text-sm text-gray-400">프로젝트를 추가하고 관리하세요</p>
                        </div>
                        <button
                            onclick="openCreateModal()"
                            class="px-5 py-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-colors cursor-pointer flex items-center gap-2 whitespace-nowrap font-medium shadow-lg shadow-blue-600/20"
                        >
                            <i class="ri-add-line text-lg"></i>
                            새 프로젝트 추가
                        </button>
                    </div>

                    <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6" id="projectList">
                        <div class="col-span-full text-center py-8 text-gray-400">
                            <i class="ri-loader-4-line animate-spin text-2xl mb-2"></i>
                            <p>프로젝트를 불러오는 중...</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Create Project Modal -->
        <div id="createModal" class="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center z-50 hidden" onclick="if(event.target === this) closeCreateModal()">
            <div class="bg-[#161b22] border border-gray-800 rounded-xl p-6 w-full max-w-md shadow-2xl">
                <div class="flex items-center justify-between mb-6">
                    <div class="flex items-center gap-3">
                        <div class="w-10 h-10 bg-blue-600 rounded-lg flex items-center justify-center">
                            <i class="ri-add-line text-white text-lg"></i>
                        </div>
                        <h2 class="text-xl font-bold text-white">새 프로젝트 추가</h2>
                    </div>
                    <button
                        onclick="closeCreateModal()"
                        class="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-gray-800 transition-colors cursor-pointer"
                    >
                        <i class="ri-close-line text-xl text-gray-400"></i>
                    </button>
                </div>

                <form onsubmit="handleCreateProject(event)">
                    <div class="mb-4">
                        <label class="block text-sm font-medium text-gray-300 mb-2">
                            프로젝트 이름
                        </label>
                        <input
                            type="text"
                            id="projectName"
                            required
                            class="w-full px-4 py-2 bg-[#0d1117] border border-gray-700 rounded-lg focus:outline-none focus:border-blue-500 text-white text-sm"
                            placeholder="프로젝트 이름을 입력하세요"
                        />
                    </div>

                    <div class="mb-4">
                        <label class="block text-sm font-medium text-gray-300 mb-2">
                            설명
                        </label>
                        <textarea
                            id="projectDescription"
                            required
                            class="w-full px-4 py-2 bg-[#0d1117] border border-gray-700 rounded-lg focus:outline-none focus:border-blue-500 text-white text-sm resize-none"
                            rows="3"
                            placeholder="프로젝트 설명을 입력하세요"
                        ></textarea>
                    </div>

                    <div class="mb-6">
                        <label class="block text-sm font-medium text-gray-300 mb-2">
                            GitHub 저장소 URL
                        </label>
                        <input
                            type="url"
                            id="repoUrl"
                            required
                            class="w-full px-4 py-2 bg-[#0d1117] border border-gray-700 rounded-lg focus:outline-none focus:border-blue-500 text-white text-sm"
                            placeholder="https://github.com/username/repo"
                        />
                    </div>

                    <div class="flex gap-3">
                        <button
                            type="button"
                            onclick="closeCreateModal()"
                            class="flex-1 px-4 py-2 bg-gray-800 hover:bg-gray-700 text-white rounded-lg transition-colors cursor-pointer whitespace-nowrap"
                        >
                            취소
                        </button>
                        <button
                            type="submit"
                            id="submitProjectBtn"
                            class="flex-1 px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-colors cursor-pointer whitespace-nowrap font-medium flex items-center justify-center gap-2"
                        >
                            <i class="ri-check-line"></i>
                            프로젝트 추가
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // 전역 함수로 정의하여 즉시 사용 가능하도록
        window.openCreateModal = function() {
            const modal = document.getElementById('createModal');
            if (modal) {
                modal.classList.remove('hidden');
                // 폼 초기화
                const nameInput = document.getElementById('projectName');
                const descInput = document.getElementById('projectDescription');
                const urlInput = document.getElementById('repoUrl');
                if (nameInput) nameInput.value = '';
                if (descInput) descInput.value = '';
                if (urlInput) urlInput.value = '';
                // 첫 번째 입력 필드에 포커스
                setTimeout(() => {
                    if (nameInput) nameInput.focus();
                }, 100);
            }
        };

        window.closeCreateModal = function() {
            const modal = document.getElementById('createModal');
            if (modal) {
                modal.classList.add('hidden');
            }
        };
        
        // ESC 키로 모달 닫기
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                const modal = document.getElementById('createModal');
                if (!modal.classList.contains('hidden')) {
                    closeCreateModal();
                }
            }
        });

        window.loadProjects = async function() {
            const projectList = document.getElementById('projectList');
            if (!projectList) {
                console.error('projectList 요소를 찾을 수 없습니다.');
                return;
            }
            
            try {
                console.log('프로젝트 API 호출 시작...');
                const apiUrl = '<%= request.getContextPath() %>/api/projects';
                console.log('API URL:', apiUrl);
                const response = await fetch(apiUrl, {
                    method: 'GET',
                    credentials: 'same-origin',
                    headers: {
                        'Accept': 'application/json'
                    }
                });
                
                console.log('API 응답 상태:', response.status, response.statusText);
                
                if (response.status === 401) {
                    // 인증 오류 - 로그인 페이지로 리다이렉트
                    console.warn('인증 오류, 로그인 페이지로 이동');
                    window.location.href = 'login.jsp';
                    return;
                }
                
                if (!response.ok) {
                    const errorText = await response.text();
                    console.error('API 오류 응답:', errorText);
                    throw new Error('프로젝트를 불러올 수 없습니다. (HTTP ' + response.status + ')');
                }
                
                const projects = await response.json();
                console.log('프로젝트 데이터 수신:', projects);
                
                // projects가 배열인지 확인
                if (Array.isArray(projects)) {
                    displayProjects(projects);
                    updateStatistics(projects);
                    console.log('프로젝트 표시 완료, 개수:', projects.length);
                } else {
                    console.error('잘못된 응답 형식:', typeof projects, projects);
                    throw new Error('잘못된 응답 형식입니다.');
                }
            } catch (error) {
                console.error('프로젝트 로드 오류:', error);
                if (projectList) {
                    projectList.innerHTML = 
                        '<div class="col-span-full text-center py-8">' +
                        '<div class="p-6 bg-red-900/20 border border-red-800 rounded-lg max-w-md mx-auto">' +
                        '<i class="ri-error-warning-line text-3xl text-red-400 mb-3"></i>' +
                        '<p class="text-red-400 mb-2">프로젝트를 불러오는 중 오류가 발생했습니다.</p>' +
                        '<p class="text-sm text-gray-400 mb-4">' + escapeHtml(error.message) + '</p>' +
                        '<div class="flex gap-2 justify-center">' +
                        '<button onclick="loadProjects()" class="px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded-lg transition-colors cursor-pointer">' +
                        '<i class="ri-refresh-line"></i> 다시 시도' +
                        '</button>' +
                        '<button onclick="location.reload()" class="px-4 py-2 bg-gray-600 hover:bg-gray-700 text-white rounded-lg transition-colors cursor-pointer">' +
                        '<i class="ri-refresh-line"></i> 새로고침' +
                        '</button>' +
                        '</div>' +
                        '</div>' +
                        '</div>';
                }
            }
        }
        
        function displayProjects(projects) {
            const projectList = document.getElementById('projectList');
            
            if (projects.length === 0) {
                projectList.innerHTML = 
                    '<div class="col-span-full text-center py-8 text-gray-400">' +
                    '<i class="ri-folder-open-line text-4xl mb-4"></i>' +
                    '<p>아직 프로젝트가 없습니다.</p>' +
                    '<p class="text-sm mt-2">새 프로젝트를 추가해보세요!</p>' +
                    '</div>';
                return;
            }
            
            console.log('[dashboard] 프로젝트 목록:', projects);
            
            // ID가 있는 프로젝트만 필터링
            const validProjects = projects.filter(project => {
                const hasId = project.id != null && project.id !== undefined && project.id !== '';
                if (!hasId) {
                    console.warn('[dashboard] ID가 없는 프로젝트 제외:', project);
                }
                return hasId;
            });
            
            if (validProjects.length === 0) {
                projectList.innerHTML = 
                    '<div class="col-span-full text-center py-8 text-gray-400">' +
                    '<i class="ri-folder-open-line text-4xl mb-4"></i>' +
                    '<p>표시할 프로젝트가 없습니다.</p>' +
                    '</div>';
                return;
            }
            
            projectList.innerHTML = validProjects.map(project => {
                // 프로젝트 ID 확인
                const projectId = project.id;
                console.log('[dashboard] 프로젝트 ID:', projectId, '타입:', typeof projectId, '프로젝트 이름:', project.name);
                console.log('[dashboard] 전체 프로젝트 객체:', JSON.stringify(project));
                
                // ID가 없으면 빈 문자열 반환
                if (!projectId || projectId === null || projectId === undefined) {
                    console.error('[dashboard] 프로젝트 ID가 없습니다:', project);
                    return '';
                }
                
                const statusClass = project.status === '완료' ? 'bg-green-500/10 text-green-400' : 
                                   project.status === '진행중' ? 'bg-blue-500/10 text-blue-400' : 
                                   project.status === '분석중' ? 'bg-yellow-500/10 text-yellow-400' :
                                   project.status === '오류' ? 'bg-red-500/10 text-red-400' :
                                   'bg-gray-500/10 text-gray-400';
                
                // 링크 URL 생성
                const detailUrl = 'project-detail.jsp?id=' + projectId;
                console.log('[dashboard] 생성된 링크 URL:', detailUrl);
                
                // 템플릿 리터럴에서 JSP EL과 충돌을 피하기 위해 문자열 연결 사용
                return `
                    <a href="` + detailUrl + `" class="cursor-pointer">
                        <div class="p-6 bg-[#161b22] border border-gray-800 rounded-xl hover:border-blue-500 transition-colors">
                            <div class="flex items-start justify-between mb-4">
                                <div class="flex-1">
                                    <h3 class="text-lg font-semibold mb-2 text-white">\${escapeHtml(project.name)}</h3>
                                    <p class="text-sm text-gray-400 mb-3">\${escapeHtml(project.description || '')}</p>
                                </div>
                            </div>
                            <div class="flex items-center gap-4 mb-4 text-sm text-gray-400">
                                <div class="flex items-center gap-1">
                                    <i class="ri-team-line"></i>
                                    <span>` + project.members + `명</span>
                                </div>
                                <div class="flex items-center gap-1">
                                    <i class="ri-calendar-line"></i>
                                    <span>` + (project.lastUpdated || project.createdAt || '') + `</span>
                                </div>
                            </div>
                            <div class="flex items-center justify-between">
                                <span class="px-3 py-1 ` + statusClass + ` rounded-full text-sm">
                                    ` + escapeHtml(project.status) + `
                                </span>
                                <div class="flex items-center gap-2">
                                    <span class="text-sm text-gray-400">기여도</span>
                                    <span class="text-lg font-bold text-blue-400">` + project.contributionScore + `</span>
                                </div>
                            </div>
                        </div>
                    </a>
                `;
            }).join('');
        }
        
        window.updateStatistics = function(projects) {
            const totalProjectsEl = document.getElementById('totalProjects');
            if (totalProjectsEl) {
                totalProjectsEl.textContent = projects.length;
            }
            
            if (projects.length > 0) {
                const avgContribution = Math.round(
                    projects.reduce((sum, p) => sum + (p.contributionScore || 0), 0) / projects.length
                );
                const avgContributionEl = document.getElementById('avgContribution');
                if (avgContributionEl) {
                    avgContributionEl.textContent = avgContribution;
                }
                
                const totalMembers = projects.reduce((sum, p) => sum + (p.members || 0), 0);
                const totalMembersEl = document.getElementById('totalMembers');
                if (totalMembersEl) {
                    totalMembersEl.textContent = totalMembers;
                }
            } else {
                const avgContributionEl = document.getElementById('avgContribution');
                const totalMembersEl = document.getElementById('totalMembers');
                if (avgContributionEl) avgContributionEl.textContent = '0';
                if (totalMembersEl) totalMembersEl.textContent = '0';
            }
        };
        
        window.escapeHtml = function(text) {
            if (!text) return '';
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        };
        
        window.handleCreateProject = async function(event) {
            event.preventDefault();
            
            const submitButton = event.target.querySelector('button[type="submit"]');
            const originalText = submitButton.innerHTML;
            submitButton.disabled = true;
            submitButton.innerHTML = '<i class="ri-loader-4-line animate-spin"></i> 생성 중...';
            
            const name = document.getElementById('projectName').value.trim();
            const description = document.getElementById('projectDescription').value.trim();
            const repoUrl = document.getElementById('repoUrl').value.trim();
            
            if (!name || !description || !repoUrl) {
                alert('모든 필드를 입력해주세요.');
                submitButton.disabled = false;
                submitButton.innerHTML = originalText;
                return;
            }
            
            try {
                const apiUrl = '<%= request.getContextPath() %>/api/projects';
                const response = await fetch(apiUrl, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        name: name,
                        description: description,
                        repoUrl: repoUrl
                    })
                });
                
                const result = await response.json();
                
                if (result.success || response.ok) {
                    // 성공 메시지
                    const successMsg = document.createElement('div');
                    successMsg.className = 'fixed top-4 right-4 bg-green-600 text-white px-6 py-3 rounded-lg shadow-lg z-50';
                    successMsg.innerHTML = '<i class="ri-check-line"></i> 프로젝트가 생성되었습니다!<br><span class="text-sm opacity-90">GitHub 저장소를 분석하는 중입니다...</span>';
                    document.body.appendChild(successMsg);
                    
                    setTimeout(() => {
                        successMsg.remove();
                    }, 5000);
                    
                    closeCreateModal();
                    // 폼 초기화
                    document.getElementById('projectName').value = '';
                    document.getElementById('projectDescription').value = '';
                    document.getElementById('repoUrl').value = '';
                    // 프로젝트 목록 새로고침
                    await loadProjects();
                } else {
                    alert(result.error || '프로젝트 생성에 실패했습니다.');
                }
            } catch (error) {
                console.error('프로젝트 생성 오류:', error);
                alert('프로젝트 생성 중 오류가 발생했습니다: ' + error.message);
            } finally {
                submitButton.disabled = false;
                submitButton.innerHTML = originalText;
            }
        }
        
        // 전역 에러 핸들러
        window.addEventListener('error', function(event) {
            console.error('JavaScript 오류:', event.error);
            const projectList = document.getElementById('projectList');
            if (projectList) {
                projectList.innerHTML = 
                    '<div class="col-span-full text-center py-8">' +
                    '<div class="p-6 bg-red-900/20 border border-red-800 rounded-lg max-w-md mx-auto">' +
                    '<i class="ri-error-warning-line text-3xl text-red-400 mb-3"></i>' +
                    '<p class="text-red-400 mb-2">페이지 로드 중 오류가 발생했습니다.</p>' +
                    '<button onclick="location.reload()" class="px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded-lg transition-colors cursor-pointer">' +
                    '<i class="ri-refresh-line"></i> 페이지 새로고침' +
                    '</button>' +
                    '</div>' +
                    '</div>';
            }
        });
        
        // 페이지 로드 시 프로젝트 목록 불러오기
        (function init() {
            console.log('[dashboard.jsp] init 함수 시작');
            console.log('[dashboard.jsp] document.readyState:', document.readyState);
            
            // 페이지가 보이는지 확인
            const mainContainer = document.getElementById('mainContainer');
            console.log('[dashboard.jsp] mainContainer 찾기:', mainContainer ? '성공' : '실패');
            if (mainContainer) {
                mainContainer.style.display = 'flex';
                mainContainer.style.visibility = 'visible';
                mainContainer.style.opacity = '1';
                console.log('[dashboard.jsp] mainContainer 표시 설정 완료');
            } else {
                console.error('[dashboard.jsp] mainContainer를 찾을 수 없습니다!');
            }
            
            function startLoad() {
                console.log('[dashboard.jsp] startLoad 함수 호출');
                console.log('[dashboard.jsp] window.loadProjects 타입:', typeof window.loadProjects);
                console.log('[dashboard.jsp] loadProjects 타입:', typeof loadProjects);
                
                if (typeof window.loadProjects === 'function') {
                    console.log('[dashboard.jsp] window.loadProjects 호출');
                    window.loadProjects();
                } else if (typeof loadProjects === 'function') {
                    console.log('[dashboard.jsp] loadProjects 호출');
                    loadProjects();
                } else {
                    console.error('[dashboard.jsp] loadProjects 함수를 찾을 수 없습니다!');
                    console.error('[dashboard.jsp] window 객체:', window);
                }
            }
            
            if (document.readyState === 'loading') {
                console.log('[dashboard.jsp] DOM 로딩 중 - DOMContentLoaded 이벤트 등록');
                document.addEventListener('DOMContentLoaded', function() {
                    console.log('[dashboard.jsp] DOMContentLoaded 이벤트 발생');
                    setTimeout(function() {
                        console.log('[dashboard.jsp] DOMContentLoaded 후 startLoad 호출');
                        startLoad();
                    }, 100);
                });
            } else {
                console.log('[dashboard.jsp] DOM 이미 로드됨 - 즉시 startLoad 호출');
                setTimeout(function() {
                    console.log('[dashboard.jsp] 즉시 startLoad 호출');
                    startLoad();
                }, 100);
            }
        })();
        
        console.log('[dashboard.jsp] init 함수 등록 완료');
        
        // 페이지가 보이지 않을 때를 대비한 폴백
        window.addEventListener('load', function() {
            console.log('페이지 로드 완료');
            // 5초 후에도 프로젝트 목록이 로딩 중이면 에러 메시지 표시
            setTimeout(function() {
                const projectList = document.getElementById('projectList');
                if (projectList && projectList.innerHTML.includes('불러오는 중')) {
                    console.warn('프로젝트 로드 시간 초과');
                    projectList.innerHTML = 
                        '<div class="col-span-full text-center py-8">' +
                        '<div class="p-6 bg-yellow-900/20 border border-yellow-800 rounded-lg max-w-md mx-auto">' +
                        '<i class="ri-time-line text-3xl text-yellow-400 mb-3"></i>' +
                        '<p class="text-yellow-400 mb-2">로딩 시간이 오래 걸리고 있습니다.</p>' +
                        '<p class="text-sm text-gray-400 mb-4">데이터베이스 연결을 확인해주세요.</p>' +
                        '<button onclick="loadProjects()" class="px-4 py-2 bg-yellow-600 hover:bg-yellow-700 text-white rounded-lg transition-colors cursor-pointer">' +
                        '<i class="ri-refresh-line"></i> 다시 시도' +
                        '</button>' +
                        '</div>' +
                        '</div>';
                }
            }, 5000);
        });
    </script>
    
    <!-- 페이지 로드 완료 확인 -->
    <script>
        // 페이지가 완전히 로드되었는지 확인
        if (document.readyState === 'complete') {
            console.log('페이지 로드 완료 확인');
            const mainContainer = document.getElementById('mainContainer');
            if (mainContainer) {
                mainContainer.style.display = 'flex';
            }
        }
    </script>
</body>
</html>

