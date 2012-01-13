
<%@page import="javax.portlet.PortletURL"%>
<%
	/**
	 * Copyright (c) 2011 Tune IT.
	 */
%>

<%@ include file="./init.jsp"%>

<p>
	<a href="<%=portletDisplay.getURLBack()%>" class="portlet-icon-back" />Return to Full page</a>
</p>

<portlet:actionURL name="updatePreferences" var="updatePreferencesURL" />

<%
	
	String tabNames = "Top,Middle,Bottom";
	String[] imageExts = {".gif", ".jpeg", ".jpg", ".png"};
	String tabs1 = ParamUtil.getString(request, "tabs1", "Top");
	System.out.println(tabs1);
	PortletURL portletURL = renderResponse.createRenderURL();
	portletURL.setParameter("tabs1", tabs1);
	
	//new code
	Folder folder = (com.liferay.portal.kernel.repository.model.Folder)request.getAttribute(DOCUMENT_LIBRARY_FOLDER);
	System.out.println("folder (1) " + (folder!=null ? "not null" : "is null"));
	long rootFolderId = PrefsParamUtil.getLong(preferences, request, "rootFolderId", DLFolderConstants.DEFAULT_PARENT_FOLDER_ID);
	System.out.println("rootFolderId = " + rootFolderId);
	folderId = BeanParamUtil.getLong(folder, request, "folderId", rootFolderId);
	System.out.println("(1) folderId = " + folderId);
	
	if ((folder == null) && (folderId != DLFolderConstants.DEFAULT_PARENT_FOLDER_ID)) {
		try {
			folder = DLAppLocalServiceUtil.getFolder(folderId);
			System.out.println("folder (2) is " + (folder!=null ? "not null" : "is null"));
		}
		catch (NoSuchFolderException nsfe) {
			folderId = DLFolderConstants.DEFAULT_PARENT_FOLDER_ID;
			System.out.println("(2) folderId = " + folderId);
			System.out.println("after NoSuchFolderException - folderId = " + folderId);
		}
	}

	long repositoryId = scopeGroupId;
	System.out.println("(1) repositoryId = " + repositoryId);

	System.out.println("folder (3) " + (folder!=null ? "not null" : "is null"));
	if (folder != null) {
		repositoryId = folder.getRepositoryId();
		System.out.println("(2) repositoryId = " + repositoryId);
	}
	
	FileEntry fileEntry = (FileEntry)request.getAttribute(DOCUMENT_LIBRARY_FILE_ENTRY);

	long fileEntryId = BeanParamUtil.getLong(fileEntry, request, "fileEntryId");
	System.out.println("(1) fileEntryId = " + fileEntryId);
	
	if (repositoryId <= 0) {
		repositoryId = BeanParamUtil.getLong(fileEntry, request, "groupId");
		System.out.println("(4) repositoryId = " + repositoryId);
	}
	
%>

<portlet:renderURL var="currentTabURL">
	<portlet:param name="redirect" value="<%= PortalUtil.getCurrentURL(request) %>" />
	<portlet:param name="tabs1" value="<%= tabs1 %>" />
</portlet:renderURL>

<liferay-ui:tabs names="<%=tabNames%>"
	url="<%= portletURL.toString()%>">
	
	<%
	for(String newsPosition : newsPositions) {
		// Keys
		String imageURL = (String) newsMap.get(newsPosition.concat("ImageURL"));
		String newsURL = (String) newsMap.get(newsPosition.concat("NewsURL"));
		String newsText = (String) newsMap.get(newsPosition.concat("NewsText"));
		Calendar newsDate = (Calendar) newsMap.get(newsPosition.concat("NewsDate"));
	%>
	
		<liferay-ui:section>
			<div style="padding: 5px;">
				<aui:layout>
					<aui:column columnWidth="60" first="true">
						<!-- upload element -->
						<aui:form action="<%= updatePreferencesURL %>"
							enctype="multipart/form-data" method="post" name='<%= "fm-".concat(newsPosition) %>'>
							<aui:input label="News URL" name='<%= newsPosition.concat("NewsURL") %>'
								value="<%= newsURL %>" />
							<aui:input label="News text" name='<%= newsPosition.concat("NewsText") %>'
								value="<%= newsText %>" />
							<div style="margin: 5px auto 20px -2px; height: 2em;">
								<liferay-ui:input-date
									disableNamespace="<%= true %>"
									dayValue="<%= newsDate.get(Calendar.DATE) %>"
									dayParam='<%= newsPosition.concat("NewsDay") %>'
									disabled="<%= false %>"
									firstDayOfWeek="<%= newsDate.getFirstDayOfWeek() - 1 %>"
									monthParam='<%= newsPosition.concat("NewsMonth") %>'
									monthValue="<%= newsDate.get(Calendar.MONTH) %>"
									yearParam='<%= newsPosition.concat("NewsYear") %>'
									yearValue="<%= newsDate.get(Calendar.YEAR) %>"
									yearRangeStart="<%= newsDate.get(Calendar.YEAR) - 10 %>"
									yearRangeEnd="<%= newsDate.get(Calendar.YEAR) + 50 %>" />
							</div>
							<aui:input label="Image (260x250px) URL"
								name="imageURL" value="<%= imageURL %>" />
							<aui:input name="imageId" type="hidden" value="<%= imageId %>" />
							<aui:input name="folderId" type="hidden" value="<%= folderId %>" />
							<aui:input name="uploadField" type="hidden" value="<%= newsPosition %>" />
							<aui:input name="redirectURL" type="hidden" value="<%= currentTabURL %>" />
							<aui:input name="tabs1" type="hidden" value="<%= tabs1 %>" />
							<aui:input name="repositoryId" type="hidden" value="<%= repositoryId %>" />
							<liferay-ui:error
								exception="<%= DuplicateFileException.class %>"
								message="please-enter-a-unique-image-name" />
	
							<liferay-ui:error exception="<%= FileNameException.class %>">
								<liferay-ui:message
									key="image-names-must-end-with-one-of-the-following-extensions" />
								<%=StringUtil.merge(
												imageExts,
												StringPool.COMMA_AND_SPACE)%>.
							</liferay-ui:error>
	
							<liferay-ui:error exception="<%= FileSizeException.class %>"
								message="please-enter-a-file-with-a-valid-file-size" />
							<liferay-ui:error exception="<%= NoSuchFolderException.class %>"
								message="please-enter-a-valid-folder" />
	
							<liferay-ui:asset-tags-error />
	
							<aui:fieldset>
								<aui:input name='<%= newsPosition.concat("File") %>' type="file" label="Choose image" />
								<aui:button type="submit" value="Save" class="clear"/>
							</aui:fieldset>
						</aui:form>
	
					</aui:column>
					<aui:column columnWidth="40" cssClass="txt-right" last="true">
						<img src="<%= imageURL %>" alt="<%= newsText %>"  
							width="260" height="250" class="img-preview"/>
						<div class="gray clear">260x250</div>
					</aui:column>
				</aui:layout>
			</div>
		</liferay-ui:section>
	
	<%
	}
	%>

</liferay-ui:tabs>


<aui:script use="aui-base">
	var validateFile = function(fileField) {
		var value = fileField.val();

		if (value) {
			var extension = value.substring(value.lastIndexOf('.')).toLowerCase();
			var validExtensions = ['<%= StringUtil.merge(imageExts, "', '") %>'];

			if ((A.Array.indexOf(validExtensions, '*') == -1) &&
				(A.Array.indexOf(validExtensions, extension) == -1)) {

				alert('<%= UnicodeLanguageUtil.get(pageContext, "image-names-must-end-with-one-of-the-following-extensions") %> <%= StringUtil.merge(imageExts, StringPool.COMMA_AND_SPACE) %>');

				fileField.val('');
			}
		}
	};

	var onFileChange = function(event) {
		validateFile(event.currentTarget);
	};
	
	var fileFieldTop = A.one('#<portlet:namespace />topFile')
	var fileFieldMiddle = A.one('#<portlet:namespace />middleFile')
	var fileFieldBottom = A.one('#<portlet:namespace />bottomFile')

	if (fileFieldTop) {
		fileFieldTop.on('change', onFileChange);

		validateFile(fileFieldTop);
	}
	
    if (fileFieldMiddle) {
		fileFieldMiddle.on('change', onFileChange);

		validateFile(fileFieldMiddle);
	}
	
	if (fileFieldBottom) {
		fileFieldBottom.on('change', onFileChange);

		validateFile(fileFieldBottom);
	}
</aui:script>




