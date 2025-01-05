--
-- use your own License Plates
-- V1.0.0.0
--
-- @author apuehri
-- @date 02/01/2025
--
-- Copyright (c) apuehri
-- V1.0.0.0 ..... LS25 first implementation

uyoLicensePlate = {};
uyoLicensePlate.version = "1.0.0.0";
uyoLicensePlate.debug = false;
uyoLicensePlate.dir = g_currentModDirectory;
uyoLicensePlate.licensePlatesDir = getUserProfileAppPath() .. "modSettings/FS25_useYourOwnLicensePlates";

function uyoLicensePlate:loadMapData(superFunc, xmlFile, missionInfo, baseDirectory)
	print("--- loading uyoLicensePlate V".. uyoLicensePlate.version .. " (c) by aPuehri loadMapData ---");
    LicensePlateManager:superClass().loadMapData(self);

    -- check if userHelpFile exist or create Folder and copy Files
    local copiedUserHelpFile = Utils.getFilename("useYourOwnLicensePlates_Help.txt", uyoLicensePlate.licensePlatesDir.. "/");
    if not fileExists(copiedUserHelpFile) then
        --create Folder
        createFolder(uyoLicensePlate.licensePlatesDir);
        --copy help file
        local sourceDir = uyoLicensePlate.dir.. "licensePlates/";
        local sourceFile = Utils.getFilename("useYourOwnLicensePlates_Help.lua", sourceDir);
        local destFile = copiedUserHelpFile
        if fileExists(sourceFile) then
            copyFile(sourceFile, destFile, true);
        end;
        --copy i3d file
        sourceDir = uyoLicensePlate.dir;
        sourceFile = Utils.getFilename("licensePlatesCustom.i3d", sourceDir);
        destFile = Utils.getFilename("licensePlatesCustom.i3d", uyoLicensePlate.licensePlatesDir.. "/"); 
        if fileExists(sourceFile) then
            copyFile(sourceFile, destFile, true);
        end;
        --copy i3d.shapes file
        sourceDir = uyoLicensePlate.dir;
        sourceFile = Utils.getFilename("licensePlatesCustom.i3d.shapes", sourceDir);
        destFile = Utils.getFilename("licensePlatesCustom.i3d.shapes", uyoLicensePlate.licensePlatesDir.. "/");  
        if fileExists(sourceFile) then
            copyFile(sourceFile, destFile, true);
        end;
        --copy dds file
        sourceDir = uyoLicensePlate.dir;
        sourceFile = Utils.getFilename("licensePlatesCustom_diffuse.dds", sourceDir);
        destFile = Utils.getFilename("licensePlatesCustom_diffuse.dds", uyoLicensePlate.licensePlatesDir.. "/");   
        if fileExists(sourceFile) then
            copyFile(sourceFile, destFile, true);
        end;
        --copy xml file
        sourceDir = uyoLicensePlate.dir;
        sourceFile = Utils.getFilename("licensePlatesCustom.xml", sourceDir);
        destFile = Utils.getFilename("licensePlatesCustom.xml", uyoLicensePlate.licensePlatesDir.. "/");  
        if fileExists(sourceFile) then
            copyFile(sourceFile, destFile, true);
        end;
        print("--- loading uyoLicensePlate V".. uyoLicensePlate.version .. " custom license Plate copied to modSettings ---");
    end;

    --check if all files in modSettings folder present
    local checkI3dFile= Utils.getFilename("licensePlatesCustom.i3d", uyoLicensePlate.licensePlatesDir.. "/");
    local checkI3dShapesFile= Utils.getFilename("licensePlatesCustom.i3d.shapes", uyoLicensePlate.licensePlatesDir.. "/"); 
    local checkDdsFile= Utils.getFilename("licensePlatesCustom_diffuse.dds", uyoLicensePlate.licensePlatesDir.. "/"); 
    local checkXmlFile= Utils.getFilename("licensePlatesCustom.xml", uyoLicensePlate.licensePlatesDir.. "/");

    -- create license Plates
    local loadLpDir = nil;
    if fileExists(checkI3dFile) and fileExists(checkI3dShapesFile) and fileExists(checkDdsFile)and fileExists(checkXmlFile) then
        loadLpDir = uyoLicensePlate.licensePlatesDir.. "/";
    else
        loadLpDir = uyoLicensePlate.dir;
    end;

    if (loadLpDir ~= nil) then
        self.xmlFilename = Utils.getFilename('licensePlatesCustom.xml', loadLpDir);
        print("--- uyoLicensePlate V".. uyoLicensePlate.version .. " directory = "..tostring(self.xmlFilename)..")");

        
        LicensePlateManager.createLicensePlateXMLSchema();

        self.licensePlateXml = XMLFile.load("mapLicensePlates", self.xmlFilename, LicensePlateManager.xmlSchema);
        if self.licensePlateXml ~= nil then
            self.xmlReferences = 0;
            self:loadLicensePlatesFromXML(self.licensePlateXml, loadLpDir);
            
            if self.licensePlateXml ~= nil and self.xmlReferences == 0 then
                self.licensePlateXml:delete();
                self.licensePlateXml = nil;
            end;
        end;
    end;

	return true;
end;

LicensePlateManager.loadMapData = Utils.overwrittenFunction(LicensePlateManager.loadMapData, uyoLicensePlate.loadMapData);
