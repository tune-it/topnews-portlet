package com.tuneit.topnews.portlet;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.repository.model.FileEntry;
import com.liferay.portal.kernel.servlet.BrowserSnifferUtil;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.upload.UploadPortletRequest;
import com.liferay.portal.kernel.util.*;
import com.liferay.portal.service.ServiceContextFactory;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portlet.documentlibrary.*;
import com.liferay.portlet.documentlibrary.model.DLFileEntry;
import com.liferay.portlet.documentlibrary.service.DLAppServiceUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;

import javax.imageio.ImageIO;
import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletPreferences;
import javax.servlet.http.HttpServletRequest;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

public class TopNewsPortlet extends MVCPortlet {

    private static final int DEFAULT_WIDTH = 260;

    private static final int DEFAULT_HEIGHT = 250;

    private static final Log log = LogFactoryUtil.getLog(TopNewsPortlet.class);

    private static final String[] parameterNames = {"NewsURL", "NewsText", "NewsDay", "NewsMonth", "NewsYear"};

    public void updatePreferences(ActionRequest req, ActionResponse res) throws Exception {
        try {
            PortletPreferences preferences = req.getPreferences();
            UploadPortletRequest uploadRequest = PortalUtil.getUploadPortletRequest(req);
            ThemeDisplay themeDisplay = (ThemeDisplay) req.getAttribute(WebKeys.THEME_DISPLAY);

            long groupId = themeDisplay.getScopeGroupId();
            long folderId = ParamUtil.getLong(uploadRequest, TopNewsWebKeys.FOLDER_ID_PARAM_NAME);
            long repositoryId = ParamUtil.getLong(uploadRequest, TopNewsWebKeys.REPOSITORY_ID_PARAM_NAME);
            String changeLog = ParamUtil.getString(uploadRequest, TopNewsWebKeys.CHANGE_LOG_PARAM_NAME);
            String redirect = ParamUtil.getString(uploadRequest, TopNewsWebKeys.REDIRECT_URL_PARAM_NAME);
            String name = ParamUtil.getString(uploadRequest, TopNewsWebKeys.NAME_PARAM_NAME);
            String filePosition = ParamUtil.getString(uploadRequest, TopNewsWebKeys.UPLOAD_FIELD_PARAM_NAME);
            String fileFieldPosition = filePosition.concat("File");
            String fileName = uploadRequest.getFileName(fileFieldPosition);

            //check if in the next line fileName is not overridden
            String description = ParamUtil.getString(uploadRequest, "description", fileName);

            File file = uploadRequest.getFile(fileFieldPosition);
            if (file != null && fileName.length() > 0) {
                file = scaleImage(file, DEFAULT_WIDTH, DEFAULT_HEIGHT);
                log.debug(file.getName());

                String contentType = getContentType(uploadRequest, file, fileFieldPosition);

                if (contentType.equals(ContentTypes.APPLICATION_OCTET_STREAM)) {
                    String ext = GetterUtil.getString(FileUtil.getExtension(file.getName())).toLowerCase();
                    if (Validator.isNotNull(ext)) {
                        contentType = MimeTypesUtil.getContentType(ext);
                    }
                }

                // Add image
                if (Validator.isNull(name)) name = fileName;

                FileEntry fileEntry;
                try {
                    // If image exists, delete it and replace by uploaded image
                    fileEntry = DLAppServiceUtil.getFileEntry(groupId, folderId, name);
                    DLAppServiceUtil.deleteFileEntry(fileEntry.getFileEntryId());
                } catch (NoSuchFileEntryException e) {
                    // First-time upload of this image
                } finally {
                    fileEntry = DLAppServiceUtil.addFileEntry(
                            repositoryId, folderId, name, contentType, name,
                            description, changeLog, file, ServiceContextFactory.getInstance(DLFileEntry.class.getName(), req));
                }

                // form image URL
                // example of image url:
                // http://localhost:8080/documents/19/0/aperture.png
                String serverURL = PortalUtil.getPortalURL(req) + "/documents/"
                        + repositoryId + "/"// ???
                        + folderId + "/" // ???
                        + fileEntry.getTitle();

                // We need to set topImageURL value somewhere
                String paramName = filePosition + "ImageURL";
                preferences.setValue(paramName, serverURL);
            } else {
                preferences.setValue(filePosition + "ImageURL", ParamUtil.getString(uploadRequest, "imageURL"));
            }

            for (String parameterName : parameterNames) {
                String parameterKey = filePosition.concat(parameterName);
                String parameterValue = ParamUtil.getString(uploadRequest, parameterKey);
                preferences.setValue(parameterKey, parameterValue);
            }
            preferences.store();
            sendRedirect(req, res, redirect);

        } catch (DuplicateFileException |
                DuplicateFolderNameException |
                FileExtensionException |
                FileMimeTypeException |
                FileNameException |
                FileSizeException |
                NoSuchFolderException |
                NoSuchFileEntryException |
                SourceFileNameException e) {
            SessionErrors.add(req, e.getClass().getName());
        }
    }

    protected String getContentType(UploadPortletRequest uploadRequest, File file, String fileFieldPosition) {
        String contentType = GetterUtil.getString(uploadRequest.getContentType(fileFieldPosition));
        if (contentType.equals(ContentTypes.APPLICATION_OCTET_STREAM)) {
            String ext = GetterUtil.getString(
                    FileUtil.getExtension(file.getName())).toLowerCase();

            if (Validator.isNotNull(ext)) {
                contentType = MimeTypesUtil.getContentType(ext);
            }
        }
        return contentType;
    }

    protected void sendRedirect(ActionRequest actionRequest, ActionResponse actionResponse, String redirect) throws IOException {
        if (SessionErrors.isEmpty(actionRequest)) addSuccessMessage(actionRequest, actionResponse);
        if (Validator.isNull(redirect)) redirect = ParamUtil.getString(actionRequest, "redirect");
        if (Validator.isNotNull(redirect)) {
            HttpServletRequest request = PortalUtil.getHttpServletRequest(actionRequest);
            if ((BrowserSnifferUtil.isIe(request))
                    && (BrowserSnifferUtil.getMajorVersion(request) == 6.0)
                    && (redirect.contains(StringPool.POUND))) {
                String redirectToken = "&#";
                if (!redirect.contains(StringPool.QUESTION)) {
                    redirectToken = StringPool.QUESTION + redirectToken;
                }
                redirect = StringUtil.replace(redirect, StringPool.POUND, redirectToken);
            }
            actionResponse.sendRedirect(redirect);
        }
    }

    private File scaleImage(File file, int tw, int th) throws IOException {
        // Create the image
        BufferedImage image = new BufferedImage(tw, th, BufferedImage.TYPE_INT_ARGB);
        // Create the graphics
        Graphics2D graphics = image.createGraphics();
        try {
            // Set rendering hints
            graphics.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            graphics.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
            graphics.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);

            // Open the source image
            BufferedImage source = ImageIO.read(file);

            // Get width & height
            int w = source.getWidth(), h = source.getHeight();

            // Calculate the scale
            double scale = Math.min(Math.min((double) tw / (double) w, (double) th / (double) h), 1);

            // Calculate the coordinates
            int x = (int) (((double) tw - (double) w * scale) / 2.0d), y = (int) (((double) th - (double) h * scale) / 2.0d);

            // Get the scaled instance
            Image scaled = source.getScaledInstance((int) (w * scale), (int) (h * scale), Image.SCALE_SMOOTH);

            // Set the color
            graphics.setColor(new Color(0, 0, 0, 0));

            // Paint the white rectangle
            graphics.fillRect(0, 0, tw, th);

            // Draw the image
            graphics.drawImage(scaled, x, y, null);

            // If image is in vector format
        } catch (NullPointerException ne) {
            return null;
            // Always dispose the graphics
        } finally {
            graphics.dispose();
        }
        // Write the rescaled image
        File output = new File(file.getPath());
        ImageIO.write(image, "png", output);
        return output;
    }

}
