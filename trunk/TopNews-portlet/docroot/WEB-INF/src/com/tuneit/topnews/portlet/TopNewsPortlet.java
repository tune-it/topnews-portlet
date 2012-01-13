package com.tuneit.topnews.portlet;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletPreferences;
import javax.portlet.ReadOnlyException;
import javax.portlet.ValidatorException;
import javax.servlet.http.HttpServletRequest;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.servlet.BrowserSnifferUtil;
//import com.liferay.portal.kernel.servlet.ImageServletTokenUtil;
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

import com.liferay.portlet.documentlibrary.model.DLContent;
import com.liferay.portlet.documentlibrary.model.*;
import com.liferay.portlet.documentlibrary.service.DLContentLocalServiceUtil;

import com.liferay.portlet.documentlibrary.DuplicateFileException;
import com.liferay.portlet.documentlibrary.DuplicateFolderNameException;
import com.liferay.portlet.documentlibrary.FileExtensionException;
import com.liferay.portlet.documentlibrary.FileMimeTypeException;
import com.liferay.portlet.documentlibrary.FileNameException;
import com.liferay.portlet.documentlibrary.FileSizeException;
import com.liferay.portlet.documentlibrary.NoSuchFileEntryException;
import com.liferay.portlet.documentlibrary.NoSuchFileVersionException;
import com.liferay.portlet.documentlibrary.NoSuchFolderException;
import com.liferay.portlet.documentlibrary.SourceFileNameException;
import com.liferay.portlet.documentlibrary.model.DLFileEntry;
import com.liferay.portlet.documentlibrary.service.DLAppServiceUtil;
import com.liferay.portlet.documentlibrary.util.DLUtil;

import com.liferay.portal.kernel.repository.model.FileEntry;

import com.liferay.util.bridges.mvc.MVCPortlet;

public class TopNewsPortlet extends MVCPortlet {

    private static Log log = LogFactoryUtil.getLog(TopNewsPortlet.class);

    private static final String[] parameterNames = { "NewsURL",
            "NewsText", "NewsDay", "NewsMonth", "NewsYear" };

    public void updatePreferences(ActionRequest req, ActionResponse res)
            throws ReadOnlyException, ValidatorException, IOException,
            Exception {
        try {
            System.out.println("==== Start action method ===");
            PortletPreferences preferences = req.getPreferences();
            UploadPortletRequest uploadRequest = PortalUtil.getUploadPortletRequest(req);
            ThemeDisplay themeDisplay = (ThemeDisplay) req.getAttribute(WebKeys.THEME_DISPLAY);

            long groupId = themeDisplay.getScopeGroupId();
            System.out.println("(1) groupId = " + groupId);
            
            long folderId = ParamUtil.getLong(uploadRequest, "folderId");
            System.out.println("(1) folderId = " + folderId);
            
            long repositoryId = ParamUtil.getLong(uploadRequest, "repositoryId");
            System.out.println("(1) repositoryId = " + repositoryId);
            
            String changeLog = ParamUtil.getString(uploadRequest, "changeLog");
            System.out.println("(1) changeLog = " + changeLog);
            
            String redirect = ParamUtil.getString(uploadRequest, "redirectURL");
            System.out.println("(1) redirectURL = " + redirect);
            
            String name = ParamUtil.getString(uploadRequest, "name");
            System.out.println("(1) name = " + name);
            
            String filePosition = ParamUtil.getString(uploadRequest, "uploadField");
            System.out.println("(1) filePosition = " + filePosition);
            
            String fileFieldPosition = filePosition + "File";
            System.out.println("(1) fileFieldPosition = " + fileFieldPosition);
            
            String fileName = uploadRequest.getFileName(fileFieldPosition);
            System.out.println("(1) fileName = " + fileName);
            
            //check if in the next line fileName is not overriden
            String description = ParamUtil.getString(uploadRequest,
                    "description", fileName);
            System.out.println("(1) description = " + description);
            
            File file = uploadRequest.getFile(fileFieldPosition);
            if (file != null && fileName.length() > 0) {
                
                file = scaleImage(file, 260, 250);
                log.debug(file.getName());
                System.out.println("file.getName = " + file.getName());
                
                String contentType = getContentType(uploadRequest, file,
                        fileFieldPosition);
                System.out.println("file - (1) contentType = " + contentType);

                if (contentType.equals(ContentTypes.APPLICATION_OCTET_STREAM)) {
                    String ext = GetterUtil.getString(
                            FileUtil.getExtension(file.getName()))
                            .toLowerCase();
                    System.out.println("file - ext = " + ext);
                    if (Validator.isNotNull(ext)) {
                        contentType = MimeTypesUtil.getContentType(ext);
                        System.out.println("file - (2) contentType = " + contentType);
                    }
                }

              ServiceContext serviceContext = ServiceContextFactory
              .getInstance(DLFileEntry.class.getName(), req);


                // Add image
                if (Validator.isNull(name)) {
                    name = fileName;
                    System.out.println("(2) name (Validator.isNull(name)) = " + name);
                }
                
                //title is the same as source file name
                String title = name;
                
                FileEntry fileEntry = null;

                try {
//                    // If image exists, delete it and replace by uploaded image
                    System.out.println("before removing the same file");
                    fileEntry = DLAppServiceUtil.getFileEntry(groupId, folderId, name);
                    DLAppServiceUtil.deleteFileEntry(fileEntry.getFileEntryId());
                    System.out.println("removing the same file is OK");
                    
                } catch(NoSuchFileEntryException e){
              // First-time upload of this image
                  System.out.println("NoSuchFileEntryException - it's a first time loading this file");
              } 
                finally {
                    System.out.println("Before adding file Entry");
                    System.out.println("ba repositoryId " + repositoryId);
                    System.out.println("ba folderId " + folderId);
                    System.out.println("ba name " + name);
                    System.out.println("ba contentType " + contentType);
                    System.out.println("ba title " + title);
                    System.out.println("ba description " + description);
                    System.out.println("ba changeLog " + changeLog);
                    System.out.println("ba file " + file.getName());
                    System.out.println("ba serviceContext " + serviceContext.toString());
                    fileEntry = DLAppServiceUtil.addFileEntry(
                            repositoryId, folderId, name, contentType, title,
                            description, changeLog, file, serviceContext);
                    System.out.println("After adding file Entry");
                }      

                // form image URL
                // example of image url:
                // http://localhost:8080/documents/19/0/aperture.png
                System.out.println("title of file entry = "
                        + fileEntry.getTitle());
                String serverURL = PortalUtil.getPortalURL(req) + "/documents/"
                        + repositoryId + "/"// ???
                        + folderId + "/" // ???
                        + fileEntry.getTitle();

                System.out.println("url of image = " + serverURL);
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
            System.out.println("==== End action method ===");

        } catch (Exception e) {
            if (e instanceof DuplicateFileException ||
                    e instanceof DuplicateFolderNameException ||
                    e instanceof FileExtensionException ||
                    e instanceof FileMimeTypeException ||
                    e instanceof FileNameException ||
                    e instanceof FileSizeException ||
                    e instanceof NoSuchFolderException ||
                    e instanceof NoSuchFileEntryException ||
                    e instanceof SourceFileNameException) {
                SessionErrors.add(req, e.getClass().getName());
                System.out.println("Exception happened (1) " + e.getLocalizedMessage());
            } else {
                System.out.println("Exception happened (2) " + e.getLocalizedMessage());
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
            double scale = Math.min(Math.min((double)tw / (double)w, (double)th / (double)h), 1);
            
            // Calculate the coordinates
            int x = (int)(((double)tw - (double)w * scale) / 2.0d), y = (int)(((double)th - (double)h * scale) / 2.0d);
            
            // Get the scaled instance
            Image scaled = source.getScaledInstance((int)(w * scale), (int)(h * scale), Image.SCALE_SMOOTH);
            
            // Set the color
            graphics.setColor(new Color(0, 0, 0,0));
            
            // Paint the white rectangle
            graphics.fillRect(0, 0, tw, th);
            
            // Draw the image
            graphics.drawImage(scaled, x, y, null);
            
        // If image is in vector format
        } catch(NullPointerException ne){
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
