package com.tuneit.topnews.portlet;

import java.io.File;
import java.io.IOException;
import java.util.Enumeration;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletPreferences;
import javax.portlet.ReadOnlyException;
import javax.portlet.ValidatorException;
import javax.servlet.http.HttpServletRequest;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.servlet.BrowserSnifferUtil;
import com.liferay.portal.kernel.servlet.ImageServletTokenUtil;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.upload.UploadPortletRequest;
import com.liferay.portal.kernel.util.ContentTypes;
import com.liferay.portal.kernel.util.FileUtil;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.MimeTypesUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portal.service.ServiceContextFactory;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portlet.bookmarks.NoSuchFolderException;
import com.liferay.portlet.imagegallery.DuplicateImageNameException;
import com.liferay.portlet.imagegallery.ImageNameException;
import com.liferay.portlet.imagegallery.ImageSizeException;
import com.liferay.portlet.imagegallery.NoSuchImageException;
import com.liferay.portlet.imagegallery.model.IGImage;
import com.liferay.portlet.imagegallery.service.IGImageServiceUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;

public class TopNewsPortlet extends MVCPortlet {

    private static Log _log = LogFactoryUtil.getLog(TopNewsPortlet.class);

    private static final String[] parameterNames = { "newsURL",
            "newsText", "newsDay", "newsMonth", "newsYear" };

    public void updatePreferences(ActionRequest req, ActionResponse res)
            throws ReadOnlyException, ValidatorException, IOException,
            Exception {
        try {
            PortletPreferences preferences = req.getPreferences();
            UploadPortletRequest uploadRequest = PortalUtil.getUploadPortletRequest(req);
            ThemeDisplay themeDisplay = (ThemeDisplay) req.getAttribute(WebKeys.THEME_DISPLAY);

            long groupId = themeDisplay.getScopeGroupId();
            long folderId = ParamUtil.getLong(uploadRequest, "folderId");
            
            String redirect = ParamUtil.getString(uploadRequest, "redirectURL");
            
            String name = ParamUtil.getString(uploadRequest, "name");
            String filePosition = ParamUtil.getString(uploadRequest,
                    "uploadField");
            String fileFieldPosition = filePosition + "File";
            String fileName = uploadRequest.getFileName(fileFieldPosition);
            String description = ParamUtil.getString(uploadRequest,
                    "description", fileName);
            
            File file = uploadRequest.getFile(fileFieldPosition);

            if (file != null && fileName.length() > 0) {
                System.out.println(file.getName());
                String contentType = getContentType(uploadRequest, file,
                        fileFieldPosition);

                if (contentType.equals(ContentTypes.APPLICATION_OCTET_STREAM)) {
                    String ext = GetterUtil.getString(
                            FileUtil.getExtension(file.getName()))
                            .toLowerCase();
                    if (Validator.isNotNull(ext)) {
                        contentType = MimeTypesUtil.getContentType(ext);
                    }
                }

                ServiceContext serviceContext = ServiceContextFactory
                        .getInstance(IGImage.class.getName(), req);

                // Add image
                if (Validator.isNull(name)) {
                    name = fileName;
                }
                
                IGImage image = null;
                try {
                    // If image exists, delete it and replace by uploaded image
                    image = IGImageServiceUtil.getImageByFolderIdAndNameWithExtension(groupId, folderId, name);
                    IGImageServiceUtil.deleteImage(image.getImageId());
                } catch(NoSuchImageException e){
                    // First-time upload of this image
                } finally {
                    image = IGImageServiceUtil.addImage(groupId, folderId,
                            name, description, file, contentType, serviceContext);
                }      

                // form image URL
                String serverURL = PortalUtil.getPortalURL(req)
                        + "/image/image_gallery?uuid="
                        + image.getUuid()
                        + "&groupId="
                        + image.getGroupId()
                        + "&t="
                        + ImageServletTokenUtil.getToken(image
                                .getLargeImageId());
                
                // We need to set topImageURL value somewhere
                String paramName = filePosition + "ImageURL";
                preferences.setValue(paramName, serverURL);
            } else {
                preferences.setValue(filePosition + "ImageURL", ParamUtil.getString(uploadRequest, "imageURL"));
            }
            
            for (String parameterName : parameterNames) {
                String parameterKey = filePosition
                        + parameterName.substring(0, 1).toUpperCase()
                        + parameterName.substring(1, parameterName.length());
                String parameterValue = ParamUtil.getString(uploadRequest, parameterName);
                preferences.setValue(parameterKey, parameterValue);
            }
            
            preferences.store();
            
            sendRedirect(req, res, redirect);

        } catch (Exception e) {
            if (e instanceof DuplicateImageNameException
                    || e instanceof ImageNameException
                    || e instanceof ImageSizeException
                    || e instanceof NoSuchFolderException) {

                SessionErrors.add(req, e.getClass().getName());
            } else {
                throw e;
            }
        }
    }
    
    protected String getContentType(UploadPortletRequest uploadRequest,
            File file, String fileFieldPosition) {

        String contentType = GetterUtil.getString(uploadRequest
                .getContentType(fileFieldPosition));

        if (contentType.equals(ContentTypes.APPLICATION_OCTET_STREAM)) {
            String ext = GetterUtil.getString(
                    FileUtil.getExtension(file.getName())).toLowerCase();

            if (Validator.isNotNull(ext)) {
                contentType = MimeTypesUtil.getContentType(ext);
            }
        }

        return contentType;
    }

    protected void sendRedirect(ActionRequest actionRequest,
            ActionResponse actionResponse, String redirect) throws IOException {

        if (SessionErrors.isEmpty(actionRequest)) {
            addSuccessMessage(actionRequest, actionResponse);
        }

        if (Validator.isNull(redirect)) {
            redirect = ParamUtil.getString(actionRequest, "redirect");
        }

        if (Validator.isNotNull(redirect)) {
            HttpServletRequest request = PortalUtil
                    .getHttpServletRequest(actionRequest);

            if ((BrowserSnifferUtil.isIe(request))
                    && (BrowserSnifferUtil.getMajorVersion(request) == 6.0)
                    && (redirect.contains(StringPool.POUND))) {

                String redirectToken = "&#";

                if (!redirect.contains(StringPool.QUESTION)) {
                    redirectToken = StringPool.QUESTION + redirectToken;
                }

                redirect = StringUtil.replace(redirect, StringPool.POUND,
                        redirectToken);
            }

            actionResponse.sendRedirect(redirect);
        }
    }
    
}
