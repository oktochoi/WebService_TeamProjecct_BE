<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 관리 - 관리자</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        /* Slight adjustments to fit admin table in dark dashboard theme */
        .content-wrap { padding: 2rem; }
        .card-bg { background-color: #0d1117; border: 1px solid #1f2937; }
    </style>
</head>
<body class="bg-[#0d1117] text-white">

<%@ include file="/includes/sidebar.jsp" %>

<div class="flex-1 ml-64">
    <nav class="border-b border-gray-800 bg-[#161b22] sticky top-0 z-10">
        <div class="px-8 py-4">
            <div class="flex items-center justify-between mb-2">
                <h1 class="text-2xl font-bold text-white">회원 관리</h1>
                <div class="flex items-center gap-3">
                    <!-- keep settings icon for consistency with dashboard -->
                    <a href="/settings.jsp" class="w-9 h-9 flex items-center justify-center rounded-lg hover:bg-gray-800 transition-colors cursor-pointer">
                        <i class="ri-settings-3-line text-xl text-gray-300"></i>
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <div class="content-wrap">
        <div class="max-w-7xl mx-auto">

            <c:if test="${not empty param.success}">
                <!-- Show a JS alert for deletion success, then reload without it -->
                <script>
                    (function(){
                        try {
                            // show alert
                            alert('삭제되었습니다.');
                            // remove 'success' param and reload without it
                            const url = new URL(window.location.href);
                            url.searchParams.delete('success');
                            // replace state then reload
                            window.history.replaceState({}, '', url.pathname + (url.search ? ('?' + url.searchParams.toString()) : ''));
                            // reload to refresh list data
                            window.location.reload();
                        } catch(e) {
                            console.error(e);
                        }
                    })();
                </script>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="mb-4 p-3 rounded-lg bg-red-900/20 border border-red-800 text-red-200">${fn:escapeXml(param.error)}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="mb-4 p-3 rounded-lg bg-red-900/20 border border-red-800 text-red-200">${fn:escapeXml(error)}</div>
            </c:if>

            <div class="card-bg rounded-xl overflow-hidden">
                <div class="p-4 border-b border-gray-800 flex items-center justify-between">
                    <div>
                        <h2 class="text-lg font-semibold">전체 사용자</h2>
                        <p class="text-xs text-gray-400">총 <span class="text-gray-200">${fn:length(users)}</span>명</p>
                    </div>
                    <div>
                        <!-- placeholder for potential filters in future -->
                    </div>
                </div>

                <div class="p-4 overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-700">
                        <thead class="bg-[#0b1220]">
                        <tr>
                            <th class="px-4 py-3 text-left text-xs font-medium text-gray-400">ID</th>
                            <th class="px-4 py-3 text-left text-xs font-medium text-gray-400">사용자명</th>
                            <th class="px-4 py-3 text-left text-xs font-medium text-gray-400">이메일</th>
                            <th class="px-4 py-3 text-left text-xs font-medium text-gray-400">권한</th>
                            <th class="px-4 py-3 text-left text-xs font-medium text-gray-400">가입일</th>
                            <th class="px-4 py-3 text-left text-xs font-medium text-gray-400">작업</th>
                        </tr>
                        </thead>
                        <tbody class="bg-[#071018] divide-y divide-gray-800">
                        <c:choose>
                            <c:when test="${empty users}">
                                <tr>
                                    <td colspan="6" class="px-4 py-6 text-center text-gray-400">등록된 사용자가 없습니다.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="user" items="${users}">
                                    <tr>
                                        <td class="px-4 py-3 text-sm text-gray-200">${user.id}</td>
                                        <td class="px-4 py-3 text-sm text-gray-200">${fn:escapeXml(user.username != null ? user.username : (user.email != null ? user.email : '-'))}</td>
                                        <td class="px-4 py-3 text-sm text-gray-200">${fn:escapeXml(user.email != null ? user.email : '-')}</td>
                                        <td class="px-4 py-3 text-sm text-gray-200">${fn:escapeXml(user.userRole != null ? user.userRole : '-')}</td>
                                        <td class="px-4 py-3 text-sm text-gray-200"><c:out value="${user.createdAt}"/></td>
                                        <td class="px-4 py-3 text-sm text-gray-200">
                                            <c:choose>
                                                <c:when test="${not empty sessionScope.loginUser and sessionScope.loginUser.id == user.id}">
                                                    <button class="px-3 py-1 rounded bg-gray-600 text-gray-300 text-sm" disabled>삭제</button>
                                                </c:when>
                                                <c:otherwise>
                                                    <form method="post" action="${pageContext.request.contextPath}/admin/users/delete" onsubmit="return confirm('정말 삭제하시겠습니까?');" style="display:inline-block;">
                                                        <input type="hidden" name="userId" value="${user.id}" />
                                                        <button type="submit" class="px-3 py-1 rounded bg-red-600 hover:bg-red-700 text-white text-sm">삭제</button>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>


        </div>
    </div>
</div>

</body>
</html>
