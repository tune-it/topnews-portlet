<%
    /**
     * Copyright (c) 2013-19 Tune IT.
     */
%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>

<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>

<%@ page import="java.util.ResourceBundle" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.text.DateFormat"%>

<%@ page import="javax.portlet.WindowState" %>
<%@ page import="javax.portlet.PortletPreferences" %>

<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="com.liferay.portal.kernel.util.Validator"%>
<%@ page import="com.liferay.portal.kernel.util.StringPool" %>
<%@ page import="com.liferay.portal.kernel.util.CalendarFactoryUtil" %>
<%@ page import="com.liferay.portal.kernel.portlet.PortletPreferencesFactoryUtil"%>
<%@ page import="com.liferay.portal.kernel.util.PrefsPropsUtil" %>
<%@ page import="com.liferay.portal.kernel.language.LanguageUtil" %>
<%@ page import="com.liferay.portal.kernel.language.UnicodeLanguageUtil" %>
<%@ page import="com.liferay.portal.kernel.util.HtmlUtil" %>
<%@ page import="com.liferay.portal.kernel.util.PropsKeys" %>
<%@ page import="com.liferay.portal.kernel.util.StringUtil" %>

<%@ page import="com.liferay.document.library.kernel.exception.DuplicateFileException" %>
<%@ page import="com.liferay.document.library.kernel.exception.FileNameException" %>
<%@ page import="com.liferay.document.library.kernel.exception.FileSizeException" %>
<%@ page import="com.liferay.document.library.kernel.exception.NoSuchFolderException" %>

<%@ page import="com.liferay.portal.kernel.util.PortalUtil" %>

<%@ page import="com.liferay.portal.kernel.bean.BeanParamUtil" %>
<%@ page import="com.liferay.portal.kernel.repository.model.FileEntry" %>

<%@ page import="com.liferay.document.library.kernel.service.DLAppLocalServiceUtil" %>
<%@ page import="com.liferay.document.library.kernel.model.DLFolder" %>
<%@ page import="com.liferay.document.library.kernel.model.DLFolderConstants" %>
<%@ page import="com.liferay.document.library.kernel.model.DLSearchConstants" %>

<%@ page import="com.liferay.portal.kernel.repository.model.Folder" %>
<%@ page import="com.liferay.portal.kernel.util.PrefsParamUtil" %>

<portlet:defineObjects />
<liferay-theme:defineObjects />

<%
    final String DOCUMENT_LIBRARY_FOLDER = "DOCUMENT_LIBRARY_FOLDER";
    final String DOCUMENT_LIBRARY_FOLDERS = "DOCUMENT_LIBRARY_FOLDERS";
    final String DOCUMENT_LIBRARY_FILE_ENTRY = "DOCUMENT_LIBRARY_FILE_ENTRY";

    ResourceBundle res = portletConfig.getResourceBundle(locale);

    PortletPreferences preferences = renderRequest.getPreferences();

    String portletResource = ParamUtil.getString(request, "portletResource");

    if (Validator.isNotNull(portletResource)) {
        preferences = PortletPreferencesFactoryUtil.getPortletSetup(request, portletResource);
    }

    Calendar defaultValueDate = CalendarFactoryUtil.getCalendar(timeZone, locale);
    DateFormat format = new SimpleDateFormat("dd.MM.yyyy", locale);

    String[] newsPositions = {"top", "middle", "bottom"};
    Map<String, Object> newsMap = new HashMap<String, Object>();

    for (String newsPosition : newsPositions) {
        // Keys
        String imageURLKey = newsPosition.concat("ImageURL");
        String newsURLKey = newsPosition.concat("NewsURL");
        String newsTextKey = newsPosition.concat("NewsText");
        String newsDayKey = newsPosition.concat("NewsDay");
        String newsMonthKey = newsPosition.concat("NewsMonth");
        String newsYearKey = newsPosition.concat("NewsYear");
        String newsDateKey = newsPosition.concat("NewsDate");

        newsMap.put(imageURLKey, preferences.getValue(imageURLKey, "/o/topnews-portlet/img/default-news.png"));
        newsMap.put(newsURLKey, preferences.getValue(newsURLKey, "https://www.tune-it.ru"));
        newsMap.put(newsTextKey, preferences.getValue(newsTextKey, "You can change text/image in portlet preferences."));

        // Date
        String newsDay = preferences.getValue(newsDayKey, null);
        String newsMonth = preferences.getValue(newsMonthKey, null);
        String newsYear = preferences.getValue(newsYearKey, null);
        Calendar newsDate = defaultValueDate;
        if (newsDay != null && newsMonth != null && newsYear != null) {
            newsDate = CalendarFactoryUtil.getCalendar(Integer.parseInt(newsYear), Integer.parseInt(newsMonth), Integer.parseInt(newsDay));
        }
        newsMap.put(newsDateKey, newsDate);
    }

//Upload element initialization variables
    long imageId = 0;
    long folderId = 0;

%>