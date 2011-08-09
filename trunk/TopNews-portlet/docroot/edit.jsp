
<%
	/**
	 * Copyright (c) 2011 Tune IT.
	 */
%>

<%@ include file="./init.jsp"%>

<p>
	<a href="<%=portletDisplay.getURLBack()%>" class="portlet-icon-back" />Return
	to Full page</a>
</p>

<%! String redirectURL = ""; %>

<%
	if (redirectURL.isEmpty()) {
		redirectURL = PortalUtil.getCurrentCompleteURL(request);
	}
	System.out.println("redirectURL is: " + redirectURL);

	/*
	String redirectURL = preferences.getValue("redirectURL", "");
	if (redirectURL.isEmpty()) {
		redirectURL = PortalUtil.getCurrentCompleteURL(request);
		preferences.setValue("redirectURL", redirectURL);
		preferences.store();
	}
	*/
%>

<portlet:actionURL name="uploadImage" var="uploadImageURL" />

<%
	String tabNames = "Top,Middle,Bottom";
%>

<liferay-ui:tabs names="<%=tabNames%>" refresh="false">
	<liferay-ui:section>
		<div style="padding: 5px;">
			<aui:layout>
				<aui:column columnWidth="60" first="true">
					<aui:input id="topNewsURL" label="News URL" name="topNewsURL"
						value="<%= topNewsURL %>" />
					<aui:input id="topNewsText" label="News text" name="topNewsText"
						value="<%= topNewsText %>" />
					<aui:input id="topImageURL" label="Image (210x200px) URL"
						name="topImageURL" value="<%= topImageURL %>" />

					<!-- top upload element -->
					<aui:form action="<%= uploadImageURL %>"
						enctype="multipart/form-data" method="post" name="fm"
						onSubmit='<%= "event.preventDefault(); " + HtmlUtil.escape(topUploadProgressId) + ".startProgress(); " + renderResponse.getNamespace() + "saveImage();" %>'>
						<aui:input name="uploadProgressId" type="hidden"
							value="<%= topUploadProgressId %>" />
						<aui:input name="imageId" type="hidden" value="<%= imageId %>" />
						<aui:input name="folderId" type="hidden" value="<%= folderId %>" />
						<aui:input name="uploadField" type="hidden" value="top" />
						<aui:input name="redirectURL" type="hidden" value="<%= redirectURL %>" />
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
							<aui:button type="submit" value="Upload" />
						</aui:fieldset>
					</aui:form>

					<liferay-ui:upload-progress id="<%= topUploadProgressId %>"
						message="uploading" redirect="" />

					<liferay-ui:input-date
						dayValue="<%= topNewsDate.get(Calendar.DATE) %>"
						dayParam="topNewsDay" disabled="<%= false %>"
						firstDayOfWeek="<%= topNewsDate.getFirstDayOfWeek() - 1 %>"
						monthParam="topNewsMonth"
						monthValue="<%= topNewsDate.get(Calendar.MONTH) %>"
						yearParam="topNewsYear"
						yearValue="<%= topNewsDate.get(Calendar.YEAR) %>"
						yearRangeStart="<%= topNewsDate.get(Calendar.YEAR) %>"
						yearRangeEnd="<%= topNewsDate.get(Calendar.YEAR) + 50 %>" />

					<aui:button onClick="updatePreferences('top')" value="Save" />
				</aui:column>
				<aui:column columnWidth="40" last="true">
					<img src="<%=topImageURL%>" alt="<%=topNewsText%>" width="210"
						height="200" />
				</aui:column>
			</aui:layout>
		</div>
	</liferay-ui:section>
	<liferay-ui:section>
		<div style="padding: 5px;">
			<aui:layout>
				<aui:column columnWidth="60" first="true">
					<aui:input id="middleNewsURL" label="News URL" name="middleNewsURL"
						value="<%= middleNewsURL %>" />
					<aui:input id="middleNewsText" label="News text"
						name="middleNewsText" value="<%= middleNewsText %>" />
					<aui:input id="middleImageURL" label="Image (210x200px) URL"
						name="middleImageURL" value="<%= middleImageURL %>" />

					<!-- middle upload element -->
					<aui:form action="<%= uploadImageURL %>"
						enctype="multipart/form-data" method="post" name="fm"
						onSubmit='<%= "event.preventDefault(); " + HtmlUtil.escape(middleUploadProgressId) + ".startProgress(); " + renderResponse.getNamespace() + "saveImage();" %>'>
						<aui:input name="uploadProgressId" type="hidden"
							value="<%= middleUploadProgressId %>" />
						<aui:input name="imageId" type="hidden" value="<%= imageId %>" />
						<aui:input name="folderId" type="hidden" value="<%= folderId %>" />
						<aui:input name="uploadField" type="hidden" value="middle" />
						<aui:input name="redirectURL" type="hidden" value="<%= redirectURL %>" />
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
							<aui:button type="submit" value="Upload" />
						</aui:fieldset>
					</aui:form>

					<liferay-ui:upload-progress id="<%= middleUploadProgressId %>"
						message="uploading" redirect="" />

					<liferay-ui:input-date
						dayValue="<%= middleNewsDate.get(Calendar.DATE) %>"
						dayParam="middleNewsDay" disabled="<%= false %>"
						firstDayOfWeek="<%= middleNewsDate.getFirstDayOfWeek() - 1 %>"
						monthParam="middleNewsMonth"
						monthValue="<%= middleNewsDate.get(Calendar.MONTH) %>"
						yearParam="middleNewsYear"
						yearValue="<%= middleNewsDate.get(Calendar.YEAR) %>"
						yearRangeStart="<%= middleNewsDate.get(Calendar.YEAR) %>"
						yearRangeEnd="<%= middleNewsDate.get(Calendar.YEAR) + 50 %>" />
					<aui:button onClick="updatePreferences('middle')" value="Save" />
				</aui:column>
				<aui:column columnWidth="40" last="true">
					<img src="<%=middleImageURL%>" alt="<%=middleNewsText%>"
						width="210" height="200"> 
				</aui:column>
			</aui:layout>
		</div>
	</liferay-ui:section>
	<liferay-ui:section>
		<div style="padding: 5px;">
			<aui:layout>
				<aui:column columnWidth="60" first="true">
					<aui:input id="bottomNewsURL" label="News URL" name="bottomNewsURL"
						value="<%= bottomNewsURL %>" />
					<aui:input id="bottomNewsText" label="News text"
						name="bottomNewsText" value="<%= bottomNewsText %>" />
					<aui:input id="bottomImageURL" label="Image (210x200px) URL"
						name="bottomImageURL" value="<%= bottomImageURL %>" />

					<!-- bottom upload element -->
					<aui:form action="<%= uploadImageURL %>"
						enctype="multipart/form-data" method="post" name="fm"
						onSubmit='<%= "event.preventDefault(); " + HtmlUtil.escape(bottomUploadProgressId) + ".startProgress(); " + renderResponse.getNamespace() + "saveImage();" %>'>
						<aui:input name="uploadProgressId" type="hidden"
							value="<%= bottomUploadProgressId %>" />
						<aui:input name="imageId" type="hidden" value="<%= imageId %>" />
						<aui:input name="folderId" type="hidden" value="<%= folderId %>" />
						<aui:input name="uploadField" type="hidden" value="bottom" />
						<aui:input name="redirectURL" type="hidden" value="<%= redirectURL %>" />
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
							<aui:button type="submit" value="Upload" />
						</aui:fieldset>
					</aui:form>

					<liferay-ui:upload-progress id="<%= bottomUploadProgressId %>"
						message="uploading" redirect="" />

					<liferay-ui:input-date
						dayValue="<%= bottomNewsDate.get(Calendar.DATE) %>"
						dayParam="bottomNewsDay" disabled="<%= false %>"
						firstDayOfWeek="<%= bottomNewsDate.getFirstDayOfWeek() - 1 %>"
						monthParam="bottomNewsMonth"
						monthValue="<%= bottomNewsDate.get(Calendar.MONTH) %>"
						yearParam="bottomNewsYear"
						yearValue="<%= bottomNewsDate.get(Calendar.YEAR) %>"
						yearRangeStart="<%= bottomNewsDate.get(Calendar.YEAR) %>"
						yearRangeEnd="<%= bottomNewsDate.get(Calendar.YEAR) + 50 %>" />
					<aui:button onClick="updatePreferences('bottom')" value="Save" />
				</aui:column>
				<aui:column columnWidth="40" last="true">
					<img src="<%=bottomImageURL%>" alt="<%=bottomNewsText%>"
						width="210" height="200">
				</aui:column>
			</aui:layout>
		</div>
	</liferay-ui:section>
</liferay-ui:tabs>
<portlet:actionURL name="updatePreferences" var="updatePreferencesURL" />
<aui:form name="updatePreferencesForm"
	action="<%= updatePreferencesURL.toString() %>" method="post">
	<%
		String newsPosition = "insert in tag lines!";
			System.out.println(newsPosition);
	%>
	<aui:input id="imageURL" type="hidden" name="imageURL" />
	<aui:input id="newsURL" type="hidden" name="newsURL" />
	<aui:input id="newsText" type="hidden" name="newsText" />
	<aui:input id="newsDay" type="hidden" name="newsDay" />
	<aui:input id="newsMonth" type="hidden" name="newsMonth" />
	<aui:input id="newsYear" type="hidden" name="newsYear" />
	<aui:input id="newsPosition" type="hidden" name="newsPosition" />
</aui:form>

<script type="text/javascript">
	
	function updatePreferences(newsPosition) {
		//News position
		document.getElementById('<portlet:namespace />newsPosition').value = newsPosition;
		
		//Image URL
		var imageURL = document.getElementById('<portlet:namespace />' + newsPosition + 'ImageURL').value;
		document.getElementById('<portlet:namespace />imageURL').value = imageURL;
		
		//News URL
		var newsURL = document.getElementById('<portlet:namespace />' + newsPosition + 'NewsURL').value;
		document.getElementById('<portlet:namespace />newsURL').value = newsURL;
		
		//News text
		var newsText = document.getElementById('<portlet:namespace />' + newsPosition + 'NewsText').value;
		document.getElementById('<portlet:namespace />newsText').value = newsText;
		
		//News day
		var newsDay = document.getElementById('<portlet:namespace />' + newsPosition + 'NewsDay').value;
		document.getElementById('<portlet:namespace />newsDay').value = newsDay;
		
		//News month
		var newsMonth = document.getElementById('<portlet:namespace />' + newsPosition + 'NewsMonth').value;
		document.getElementById('<portlet:namespace />newsMonth').value = newsMonth;
		
		//News year
		var newsYear = document.getElementById('<portlet:namespace />' + newsPosition + 'NewsYear').value;
		document.getElementById('<portlet:namespace />newsYear').value = newsYear;
		
		document.<portlet:namespace />updatePreferencesForm.submit();
	}

</script>

<aui:script>
	function <portlet:namespace />saveImage() {
		submitForm(document.<portlet:namespace />fm);
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




