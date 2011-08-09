<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
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

<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="com.liferay.portal.kernel.util.Validator"%>
<%@ page import="com.liferay.portal.kernel.util.StringPool" %>
<%@ page import="com.liferay.portal.kernel.util.CalendarFactoryUtil" %>
<%@ page import="com.liferay.portlet.PortletPreferencesFactoryUtil"%>
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="javax.portlet.WindowState" %>
<%@ page import="javax.portlet.PortletPreferences" %>

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

// Top
String topImageURL = preferences.getValue("topImageURL", "/Top-news-portlet/img/default-news.png");
String topNewsURL = preferences.getValue("topNewsURL", "http://www.tune-it.ru");
String topNewsText = preferences.getValue("topNewsText", "You can change text/image in portlet preferences.");
String topNewsDay = preferences.getValue("topNewsDay", null);
String topNewsMonth = preferences.getValue("topNewsMonth", null);
String topNewsYear = preferences.getValue("topNewsYear", null);
Calendar topNewsDate = defaultValueDate;
if (topNewsDay != null && topNewsMonth != null && topNewsYear != null) {
	topNewsDate = CalendarFactoryUtil.getCalendar(Integer.parseInt(topNewsYear), Integer.parseInt(topNewsMonth), Integer.parseInt(topNewsDay));
}
String topUploadProgressId = "topIdImageUploadProgress";

// Middle
String middleImageURL = preferences.getValue("middleImageURL", "");
String middleNewsURL = preferences.getValue("middleNewsURL", "");
String middleNewsText = preferences.getValue("middleNewsText", "");
String middleNewsDay = preferences.getValue("middleNewsDay", null);
String middleNewsMonth = preferences.getValue("middleNewsMonth", null);
String middleNewsYear = preferences.getValue("middleNewsYear", null);
Calendar middleNewsDate = defaultValueDate;
if (middleNewsDay != null && middleNewsMonth != null && middleNewsYear != null) {
	middleNewsDate = CalendarFactoryUtil.getCalendar(Integer.parseInt(middleNewsYear), Integer.parseInt(middleNewsMonth), Integer.parseInt(middleNewsDay));
}
String middleUploadProgressId = "middleIdImageUploadProgress";

// Bottom
String bottomImageURL = preferences.getValue("bottomImageURL", "");
String bottomNewsURL = preferences.getValue("bottomNewsURL", "");
String bottomNewsText = preferences.getValue("bottomNewsText", "");
String bottomNewsDay = preferences.getValue("bottomNewsDay", null);
String bottomNewsMonth = preferences.getValue("bottomNewsMonth", null);
String bottomNewsYear = preferences.getValue("bottomNewsYear", null);
Calendar bottomNewsDate = defaultValueDate;
if (bottomNewsDay != null && bottomNewsMonth != null && bottomNewsYear != null) {
	bottomNewsDate = CalendarFactoryUtil.getCalendar(Integer.parseInt(bottomNewsYear), Integer.parseInt(bottomNewsMonth), Integer.parseInt(bottomNewsDay));
}
String bottomUploadProgressId = "bottomIdImageUploadProgress";

//Upload element initialization variables
long imageId = 0;
long folderId = 0;

%>