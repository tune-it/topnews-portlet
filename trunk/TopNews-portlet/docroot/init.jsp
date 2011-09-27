<%
/**
* Copyright (c) 2011 Tune IT.
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
<%@ page import="com.liferay.portlet.PortletPreferencesFactoryUtil"%>
<%@ page import="com.liferay.portal.kernel.util.PrefsPropsUtil" %>
<%@ page import="com.liferay.portal.kernel.language.LanguageUtil" %>
<%@ page import="com.liferay.portal.kernel.language.UnicodeLanguageUtil" %>
<%@ page import="com.liferay.portal.kernel.util.HtmlUtil" %>
<%@ page import="com.liferay.portal.kernel.util.PropsKeys" %>
<%@ page import="com.liferay.portal.kernel.util.StringUtil" %>
<%@ page import="com.liferay.portlet.imagegallery.DuplicateImageNameException" %>
<%@ page import="com.liferay.portlet.imagegallery.ImageNameException" %>
<%@ page import="com.liferay.portlet.imagegallery.ImageSizeException" %>
<%@ page import="com.liferay.portlet.imagegallery.NoSuchFolderException" %>
<%@ page import="com.liferay.portal.util.PortalUtil" %>

<portlet:defineObjects />
<liferay-theme:defineObjects />

<%
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

for(String newsPosition : newsPositions){
	// Keys
	String imageURLKey = newsPosition.concat("ImageURL");
	String newsURLKey = newsPosition.concat("NewsURL");
	String newsTextKey = newsPosition.concat("NewsText");
	String newsDayKey = newsPosition.concat("NewsDay");
	String newsMonthKey = newsPosition.concat("NewsMonth");
	String newsYearKey = newsPosition.concat("NewsYear");
	String newsDateKey = newsPosition.concat("NewsDate");
	
	newsMap.put(imageURLKey, preferences.getValue(imageURLKey, "/Top-news-portlet/img/default-news.png"));
	newsMap.put(newsURLKey, preferences.getValue(newsURLKey, "http://www.tune-it.ru"));
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