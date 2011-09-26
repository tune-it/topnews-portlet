
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
	String tabs1 = ParamUtil.getString(request, "tabs1", "Top");
	System.out.println(tabs1);
	PortletURL portletURL = renderResponse.createRenderURL();
	portletURL.setParameter("tabs1", tabs1);
%>

<portlet:renderURL var="currentTabURL">
	<portlet:param name="redirect" value="<%= PortalUtil.getCurrentURL(request) %>" />
	<portlet:param name="tabs1" value="<%= tabs1 %>" />
</portlet:renderURL>

<liferay-ui:tabs names="<%=tabNames%>"
	url="<%= portletURL.toString()%>">
	<liferay-ui:section>
		<div style="padding: 5px;">
			<aui:layout>
				<aui:column columnWidth="60" first="true">
					<!-- top upload element -->
					<aui:form action="<%= updatePreferencesURL %>"
						enctype="multipart/form-data" method="post" name="fm"
						onSubmit='<%= "event.preventDefault(); " + HtmlUtil.escape(topUploadProgressId) + ".startProgress(); " + renderResponse.getNamespace() + "saveImage(`Top`);" %>'>
						<aui:input label="News URL" name="newsURL"
							value="<%= topNewsURL %>" />
						<aui:input label="News text" name="newsText"
							value="<%= topNewsText %>" />
						<div style="margin: 5px auto 20px -2px; height: 2em;">
							<liferay-ui:input-date
								dayValue="<%= topNewsDate.get(Calendar.DATE) %>"
								dayParam="newsDay" disabled="<%= false %>"
								firstDayOfWeek="<%= topNewsDate.getFirstDayOfWeek() - 1 %>"
								monthParam="newsMonth"
								monthValue="<%= topNewsDate.get(Calendar.MONTH) %>"
								yearParam="newsYear"
								yearValue="<%= topNewsDate.get(Calendar.YEAR) %>"
								yearRangeStart="<%= topNewsDate.get(Calendar.YEAR) %>"
								yearRangeEnd="<%= topNewsDate.get(Calendar.YEAR) + 50 %>" />
						</div>
						<aui:input label="Image (260x250px) URL"
							name="imageURL" value="<%= topImageURL %>" />
						<aui:input name="uploadProgressId" type="hidden"
							value="<%= topUploadProgressId %>" />
						<aui:input name="imageId" type="hidden" value="<%= imageId %>" />
						<aui:input name="folderId" type="hidden" value="<%= folderId %>" />
						<aui:input name="uploadField" type="hidden" value="top" />
						<aui:input name="redirectURL" type="hidden" value="<%= currentTabURL %>" />
						<aui:input name="tabs1" type="hidden" value="<%= tabs1 %>" />
						<liferay-ui:error
							exception="<%= DuplicateImageNameException.class %>"
							message="please-enter-a-unique-image-name" />

						<liferay-ui:error exception="<%= ImageNameException.class %>">
							<liferay-ui:message
								key="image-names-must-end-with-one-of-the-following-extensions" />
							<%=StringUtil.merge(
											PrefsPropsUtil
													.getStringArray(
															PropsKeys.IG_IMAGE_EXTENSIONS,
															StringPool.COMMA),
											StringPool.COMMA_AND_SPACE)%>.
						</liferay-ui:error>

						<liferay-ui:error exception="<%= ImageSizeException.class %>"
							message="please-enter-a-file-with-a-valid-file-size" />
						<liferay-ui:error exception="<%= NoSuchFolderException.class %>"
							message="please-enter-a-valid-folder" />

						<liferay-ui:asset-tags-error />

						<aui:fieldset>
							<aui:input name="topFile" type="file" label="Choose image" />
							<aui:button type="submit" value="Save" class="clear"/>
						</aui:fieldset>
					</aui:form>

					<liferay-ui:upload-progress id="<%= topUploadProgressId %>"
						message="uploading" redirect="" />

				</aui:column>
				<aui:column columnWidth="40" last="true">
					<img src="<%=topImageURL%>" alt="<%=topNewsText%>"  
						width="260" height="250" class="img-preview"/>
					<span>260x250</span>
				</aui:column>
			</aui:layout>
		</div>
	</liferay-ui:section>
	<liferay-ui:section>
		<div style="padding: 5px;">
			<aui:layout>
				<aui:column columnWidth="60" first="true">
					<!-- middle upload element -->
					<aui:form action="<%= updatePreferencesURL %>"
						enctype="multipart/form-data" method="post" name="fm333"
						onSubmit='<%= "event.preventDefault(); " + HtmlUtil.escape(middleUploadProgressId) + ".startProgress(); " + renderResponse.getNamespace() + "saveImage(`Middle`);" %>'>
						<aui:input label="News URL" name="newsURL"
							value="<%= middleNewsURL %>" />
						<aui:input label="News text" name="newsText"
							value="<%= middleNewsText %>" />
						<div style="margin: 5px auto 20px -2px; height: 2em;">
							<liferay-ui:input-date
								dayValue="<%= middleNewsDate.get(Calendar.DATE) %>"
								dayParam="newsDay" disabled="<%= false %>"
								firstDayOfWeek="<%= middleNewsDate.getFirstDayOfWeek() - 1 %>"
								monthParam="newsMonth"
								monthValue="<%= middleNewsDate.get(Calendar.MONTH) %>"
								yearParam="newsYear"
								yearValue="<%= middleNewsDate.get(Calendar.YEAR) %>"
								yearRangeStart="<%= middleNewsDate.get(Calendar.YEAR) %>"
								yearRangeEnd="<%= middleNewsDate.get(Calendar.YEAR) + 50 %>" />
						</div>
						<aui:input label="Image (260x250px) URL"
							name="imageURL" value="<%= middleImageURL %>" />
						<aui:input name="uploadProgressId" type="hidden"
							value="<%= middleUploadProgressId %>" />
						<aui:input name="imageId" type="hidden" value="<%= imageId %>" />
						<aui:input name="folderId" type="hidden" value="<%= folderId %>" />
						<aui:input name="uploadField" type="hidden" value="middle" />
						<aui:input name="redirectURL" type="hidden" value="<%= currentTabURL %>" />
						<aui:input name="tabs1" type="hidden" value="<%= tabs1 %>" />
						<liferay-ui:error
							exception="<%= DuplicateImageNameException.class %>"
							message="please-enter-a-unique-image-name" />

						<liferay-ui:error exception="<%= ImageNameException.class %>">
							<liferay-ui:message
								key="image-names-must-end-with-one-of-the-following-extensions" />
							<%=StringUtil.merge(
											PrefsPropsUtil
													.getStringArray(
															PropsKeys.IG_IMAGE_EXTENSIONS,
															StringPool.COMMA),
											StringPool.COMMA_AND_SPACE)%>.
						</liferay-ui:error>

						<liferay-ui:error exception="<%= ImageSizeException.class %>"
							message="please-enter-a-file-with-a-valid-file-size" />
						<liferay-ui:error exception="<%= NoSuchFolderException.class %>"
							message="please-enter-a-valid-folder" />

						<liferay-ui:asset-tags-error />

						<aui:fieldset>
							<aui:input name="middleFile" type="file" label="Choose image" />
							<aui:button type="submit" value="Save" class="clear"/>
						</aui:fieldset>
					</aui:form>

					<liferay-ui:upload-progress id="<%= middleUploadProgressId %>"
						message="uploading" redirect="" />

				</aui:column>
				<aui:column columnWidth="40" last="true">
					<img src="<%=middleImageURL%>" alt="<%=middleNewsText%>"
						width="260" height="250" class="img-preview" /> 
					<span>260x250</span>
				</aui:column>
			</aui:layout>
		</div>
	</liferay-ui:section>
	<liferay-ui:section>
		<div style="padding: 5px;">
			<aui:layout>
				<aui:column columnWidth="60" first="true">
					<!-- bottom upload element -->
					<aui:form action="<%= updatePreferencesURL %>"
						enctype="multipart/form-data" method="post" name="fmBottom"
						onSubmit='<%= "event.preventDefault(); " + HtmlUtil.escape(bottomUploadProgressId) + ".startProgress(); " + renderResponse.getNamespace() + "saveImage(`Bottom`);" %>'>
						<aui:input label="News URL" name="newsURL"
							value="<%= bottomNewsURL %>" />
						<aui:input label="News text" name="newsText"
							value="<%= bottomNewsText %>" />
						<div style="margin: 5px auto 20px -2px; height: 2em;">
							<liferay-ui:input-date
								dayValue="<%= bottomNewsDate.get(Calendar.DATE) %>"
								dayParam="newsDay" disabled="<%= false %>"
								firstDayOfWeek="<%= bottomNewsDate.getFirstDayOfWeek() - 1 %>"
								monthParam="newsMonth"
								monthValue="<%= bottomNewsDate.get(Calendar.MONTH) %>"
								yearParam="newsYear"
								yearValue="<%= bottomNewsDate.get(Calendar.YEAR) %>"
								yearRangeStart="<%= bottomNewsDate.get(Calendar.YEAR) %>"
								yearRangeEnd="<%= bottomNewsDate.get(Calendar.YEAR) + 50 %>" />
						</div>
						<aui:input label="Image (260x250px) URL"
							name="imageURL" value="<%= bottomImageURL %>" />
						<aui:input name="uploadProgressId" type="hidden"
							value="<%= bottomUploadProgressId %>" />
						<aui:input name="imageId" type="hidden" value="<%= imageId %>" />
						<aui:input name="folderId" type="hidden" value="<%= folderId %>" />
						<aui:input name="uploadField" type="hidden" value="bottom" />
						<aui:input name="redirectURL" type="hidden" value="<%= currentTabURL %>" />
						<aui:input name="tabs1" type="hidden" value="<%= tabs1 %>" />
						<liferay-ui:error
							exception="<%= DuplicateImageNameException.class %>"
							message="please-enter-a-unique-image-name" />

						<liferay-ui:error exception="<%= ImageNameException.class %>">
							<liferay-ui:message
								key="image-names-must-end-with-one-of-the-following-extensions" />
							<%=StringUtil.merge(
											PrefsPropsUtil
													.getStringArray(
															PropsKeys.IG_IMAGE_EXTENSIONS,
															StringPool.COMMA),
											StringPool.COMMA_AND_SPACE)%>.
						</liferay-ui:error>

						<liferay-ui:error exception="<%= ImageSizeException.class %>"
							message="please-enter-a-file-with-a-valid-file-size" />
						<liferay-ui:error exception="<%= NoSuchFolderException.class %>"
							message="please-enter-a-valid-folder" />

						<liferay-ui:asset-tags-error />

						<aui:fieldset>
							<aui:input name="bottomFile" type="file" label="Choose image" />
							<aui:button type="submit" value="Save" class="clear"/>
						</aui:fieldset>
					</aui:form>

					<liferay-ui:upload-progress id="<%= bottomUploadProgressId %>"
						message="uploading" redirect="" />

				</aui:column>
				<aui:column columnWidth="40" last="true">
					<img src="<%=bottomImageURL%>" alt="<%=bottomNewsText%>"
						width="260" height="250" class="img-preview" />
					<span>260x250</span>
				</aui:column>
			</aui:layout>
		</div>
	</liferay-ui:section>
</liferay-ui:tabs>

<aui:script>
	function <portlet:namespace />saveImage(suffix) {
		submitForm(document.<portlet:namespace />fm + suffix);
	}
</aui:script>
<aui:script use="aui-base">
	var validateFile = function(fileField) {
		var value = fileField.val();

		if (value) {
			var extension = value.substring(value.lastIndexOf('.')).toLowerCase();
			var validExtensions = ['<%= StringUtil.merge(PrefsPropsUtil.getStringArray(PropsKeys.IG_IMAGE_EXTENSIONS, StringPool.COMMA), "', '") %>'];

			if ((A.Array.indexOf(validExtensions, '*') == -1) &&
				(A.Array.indexOf(validExtensions, extension) == -1)) {

				alert('<%= UnicodeLanguageUtil.get(pageContext, "image-names-must-end-with-one-of-the-following-extensions") %> <%= StringUtil.merge(PrefsPropsUtil.getStringArray(PropsKeys.IG_IMAGE_EXTENSIONS, StringPool.COMMA), StringPool.COMMA_AND_SPACE) %>');

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




