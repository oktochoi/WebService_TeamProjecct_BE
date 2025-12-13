<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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

        <div class="border-t border-gray-800 pt-4">
            <p class="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-3 px-4">빠른 통계</p>
            <div class="space-y-3 px-4">
                <div class="flex items-center justify-between">
                    <div class="flex items-center gap-2">
                        <i class="ri-checkbox-circle-line text-green-500 text-sm"></i>
                        <span class="text-xs text-gray-400">완료된 프로젝트</span>
                    </div>
                    <span class="text-sm font-semibold text-white">3</span>
                </div>
                <div class="flex items-center justify-between">
                    <div class="flex items-center gap-2">
                        <i class="ri-chat-3-line text-blue-500 text-sm"></i>
                        <span class="text-xs text-gray-400">받은 리뷰</span>
                    </div>
                    <span class="text-sm font-semibold text-white">12</span>
                </div>
                <div class="flex items-center justify-between">
                    <div class="flex items-center gap-2">
                        <i class="ri-star-fill text-yellow-500 text-sm"></i>
                        <span class="text-xs text-gray-400">평균 평점</span>
                    </div>
                    <span class="text-sm font-semibold text-white">4.5</span>
                </div>
            </div>
        </div>
    </nav>

    <div class="p-4 border-t border-gray-800">
        <div class="flex items-center gap-3 px-4 py-3 bg-gray-800/50 rounded-lg mb-3">
            <div class="w-9 h-9 bg-gradient-to-br from-purple-500 to-pink-500 rounded-full flex items-center justify-center">
                <span class="text-white font-semibold text-sm">
                    <% 
                        // JSP에서 session은 내장 객체이므로 별도로 선언할 필요 없음
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

