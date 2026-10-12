; The installer's and uninstaller's pages, drawn here instead of with the
; Modern UI wizard. Installer: one page to install or upgrade, the progress
; page and a finish page. Uninstaller: a confirmation page, the progress page
; and a done page. Light or dark as Windows apps are set, in Vigil's palette.
; Included by installer-template.nsi after the languages, so the strings can
; be per language; keep the languages in step with tauri.conf.json.
;
; Sizes are pixels at 96 DPI; VigilScale converts them for the window's DPI
; (the installer is per-monitor DPI aware). Registers: the macros use $R0–$R9
; as scratch; page functions keep their own values in $1–$7.

!include nsDialogs.nsh

; Window styles, combined here because System::Call cannot OR them.
!define VIGIL_TEXT 0x50000101 ; WS_CHILD | WS_VISIBLE | SS_CENTER | SS_NOTIFY
!define VIGIL_LABEL 0x50000100 ; WS_CHILD | WS_VISIBLE | SS_NOTIFY
!define VIGIL_PATH 0x50008100 ; … | SS_PATHELLIPSIS
!define VIGIL_IMAGE 0x5000010E ; WS_CHILD | WS_VISIBLE | SS_NOTIFY | SS_BITMAP
!define VIGIL_ICON 0x50000043 ; WS_CHILD | WS_VISIBLE | SS_ICON | SS_REALSIZECONTROL
!define VIGIL_CHECK 0x50010003 ; WS_CHILD | WS_VISIBLE | WS_TABSTOP | BS_AUTOCHECKBOX
!define /ifndef SS_CENTER 0x1
!define /ifndef SS_PATHELLIPSIS 0x8000
!define /ifndef STM_SETICON 0x170
!define /ifndef STM_SETIMAGE 0x172
!define /ifndef PBM_SETBARCOLOR 0x409
!define /ifndef PBM_SETBKCOLOR 0x2001
!define /ifndef PBS_SMOOTH 0x1
!define /ifndef GWL_STYLE -16
!define /ifndef GWL_EXSTYLE -20

; ---- Strings ------------------------------------------------------------------

LangString VigilFace ${LANG_ENGLISH} "Segoe UI"
LangString VigilFace ${LANG_SIMPCHINESE} "Microsoft YaHei UI"
LangString VigilTagline ${LANG_ENGLISH} "A fast, modern and informative task manager for Windows"
LangString VigilTagline ${LANG_SIMPCHINESE} "快速、现代、信息丰富的 Windows 任务管理器"
LangString VigilVersion ${LANG_ENGLISH} "Version ${VERSION}"
LangString VigilVersion ${LANG_SIMPCHINESE} "版本 ${VERSION}"
LangString VigilUpgradeFrom ${LANG_ENGLISH} "Upgrades version $VigilOldVersion to ${VERSION}"
LangString VigilUpgradeFrom ${LANG_SIMPCHINESE} "将从版本 $VigilOldVersion 升级到 ${VERSION}"
LangString VigilSameVersion ${LANG_ENGLISH} "Version ${VERSION} is already installed; reinstalling repairs it"
LangString VigilSameVersion ${LANG_SIMPCHINESE} "已安装版本 ${VERSION}，重新安装可修复程序文件"
LangString VigilNewerInstalled ${LANG_ENGLISH} "A newer version ($VigilOldVersion) is installed. Uninstall it first to install ${VERSION}."
LangString VigilNewerInstalled ${LANG_SIMPCHINESE} "已安装更新的版本 $VigilOldVersion。如需安装 ${VERSION}，请先卸载。"
LangString VigilInstall ${LANG_ENGLISH} "Install"
LangString VigilInstall ${LANG_SIMPCHINESE} "立即安装"
LangString VigilUpgrade ${LANG_ENGLISH} "Upgrade"
LangString VigilUpgrade ${LANG_SIMPCHINESE} "立即升级"
LangString VigilReinstall ${LANG_ENGLISH} "Reinstall"
LangString VigilReinstall ${LANG_SIMPCHINESE} "重新安装"
LangString VigilLocation ${LANG_ENGLISH} "Install location: $INSTDIR"
LangString VigilLocation ${LANG_SIMPCHINESE} "安装位置：$INSTDIR"
LangString VigilChange ${LANG_ENGLISH} "Change"
LangString VigilChange ${LANG_SIMPCHINESE} "更改"
LangString VigilChooseFolder ${LANG_ENGLISH} "Choose the folder to install Vigil in"
LangString VigilChooseFolder ${LANG_SIMPCHINESE} "选择安装 Vigil 的文件夹"
LangString VigilInstalling ${LANG_ENGLISH} "Installing Vigil…"
LangString VigilInstalling ${LANG_SIMPCHINESE} "正在安装 Vigil…"
LangString VigilUpdating ${LANG_ENGLISH} "Updating Vigil…"
LangString VigilUpdating ${LANG_SIMPCHINESE} "正在更新 Vigil…"
LangString VigilInstalled ${LANG_ENGLISH} "Vigil is installed"
LangString VigilInstalled ${LANG_SIMPCHINESE} "安装完成"
LangString VigilInstalledText ${LANG_ENGLISH} "Open it any time from the Start menu."
LangString VigilInstalledText ${LANG_SIMPCHINESE} "Vigil 已安装到本机，可随时从开始菜单打开。"
LangString VigilDesktopShortcut ${LANG_ENGLISH} "Create a desktop shortcut"
LangString VigilDesktopShortcut ${LANG_SIMPCHINESE} "创建桌面快捷方式"
LangString VigilLaunch ${LANG_ENGLISH} "Launch Vigil"
LangString VigilLaunch ${LANG_SIMPCHINESE} "启动 Vigil"
LangString VigilClose ${LANG_ENGLISH} "Close"
LangString VigilClose ${LANG_SIMPCHINESE} "关闭"
LangString VigilUninstallTitle ${LANG_ENGLISH} "Uninstall Vigil"
LangString VigilUninstallTitle ${LANG_SIMPCHINESE} "卸载 Vigil"
LangString VigilUninstallText ${LANG_ENGLISH} "Vigil ${VERSION} will be removed from this PC."
LangString VigilUninstallText ${LANG_SIMPCHINESE} "将从本机移除 Vigil ${VERSION}。"
LangString VigilDeleteData ${LANG_ENGLISH} "Also delete settings, history and logs"
LangString VigilDeleteData ${LANG_SIMPCHINESE} "同时删除设置、历史记录与日志"
LangString VigilUninstall ${LANG_ENGLISH} "Uninstall"
LangString VigilUninstall ${LANG_SIMPCHINESE} "卸载"
LangString VigilCancel ${LANG_ENGLISH} "Cancel"
LangString VigilCancel ${LANG_SIMPCHINESE} "取消"
LangString VigilUninstalling ${LANG_ENGLISH} "Uninstalling Vigil…"
LangString VigilUninstalling ${LANG_SIMPCHINESE} "正在卸载 Vigil…"
LangString VigilUninstalled ${LANG_ENGLISH} "Vigil is uninstalled"
LangString VigilUninstalled ${LANG_SIMPCHINESE} "卸载完成"
LangString VigilUninstalledText ${LANG_ENGLISH} "Vigil has been removed from this PC."
LangString VigilUninstalledText ${LANG_SIMPCHINESE} "Vigil 已从本机移除。"

; ---- Theme --------------------------------------------------------------------

; Vigil's palette (ui/src/styles.css). SetCtlColors takes colors only as
; constants, so each role is painted from one of two fixed sets; Vigil's
; default accent is used rather than the Windows one, for the same reason.
!define VIGIL_LIGHT_BG ECEFF4
!define VIGIL_LIGHT_INK 1B1C22
!define VIGIL_LIGHT_INK2 5B5F6D
!define VIGIL_LIGHT_INK3 80848F
!define VIGIL_LIGHT_ACCENT 0067C0
!define VIGIL_LIGHT_ON_ACCENT FFFFFF
!define VIGIL_LIGHT_TRACK D5D9E2
!define VIGIL_DARK_BG 1C1D24
!define VIGIL_DARK_INK F1F2F6
!define VIGIL_DARK_INK2 A9ADBB
!define VIGIL_DARK_INK3 7A7E8F
!define VIGIL_DARK_ACCENT 4CC2FF
!define VIGIL_DARK_ON_ACCENT 00213B
!define VIGIL_DARK_TRACK 33353F

; Paints HWND in a ROLE: page, ink, ink2, ink3 or link. Text sits on the page
; color rather than a transparent background, which needs no repainting order.
!macro VigilPaint HWND ROLE
  ${If} $VigilDark = 1
    !insertmacro VigilPaint_${ROLE} ${HWND} DARK
  ${Else}
    !insertmacro VigilPaint_${ROLE} ${HWND} LIGHT
  ${EndIf}
!macroend
!macro VigilPaint_page HWND T
  SetCtlColors ${HWND} ${VIGIL_${T}_INK} ${VIGIL_${T}_BG}
!macroend
!macro VigilPaint_ink HWND T
  SetCtlColors ${HWND} ${VIGIL_${T}_INK} ${VIGIL_${T}_BG}
!macroend
!macro VigilPaint_ink2 HWND T
  SetCtlColors ${HWND} ${VIGIL_${T}_INK2} ${VIGIL_${T}_BG}
!macroend
!macro VigilPaint_ink3 HWND T
  SetCtlColors ${HWND} ${VIGIL_${T}_INK3} ${VIGIL_${T}_BG}
!macroend
!macro VigilPaint_link HWND T
  SetCtlColors ${HWND} ${VIGIL_${T}_ACCENT} ${VIGIL_${T}_BG}
!macroend

Var VigilDpi
Var VigilWidth ; page size at 96 DPI
Var VigilHeight
Var VigilInner ; page width less the side margins
Var VigilDark
Var VigilClientWidth ; in pixels
Var VigilClientHeight
Var VigilBgRef ; palette colors as COLORREF (0x00BBGGRR), for drawing
Var VigilAccentRef
Var VigilOnAccentRef
Var VigilTrackRef
Var VigilInk3Ref
Var VigilFontHero
Var VigilFontTitle
Var VigilFontBody
Var VigilFontSmall
Var VigilFontButton
Var VigilCheckBox ; the page's check box (see VigilCheck)

!macro VigilScale VAR VALUE
  IntOp ${VAR} ${VALUE} * $VigilDpi
  IntOp ${VAR} ${VAR} / 96
!macroend
!define VigilScale "!insertmacro VigilScale"

; RRGGBB to a COLORREF (0x00BBGGRR).
!macro VigilColorRef VAR HEX
  IntOp $R8 0x${HEX} + 0
  IntOp $R9 $R8 & 0xFF
  IntOp $R9 $R9 << 16
  IntOp ${VAR} $R8 & 0xFF00
  IntOp ${VAR} ${VAR} | $R9
  IntOp $R8 $R8 >> 16
  IntOp ${VAR} ${VAR} | $R8
!macroend

; A font PX pixels high (at 96 DPI) in the language's face.
!macro VigilFont VAR PX WEIGHT
  ${VigilScale} $R0 ${PX}
  IntOp $R0 0 - $R0
  System::Call 'gdi32::CreateFontW(i R0, i 0, i 0, i 0, i ${WEIGHT}, i 0, i 0, i 0, i 1, i 0, i 0, i 5, i 0, w "$(VigilFace)") p .s'
  Pop ${VAR}
!macroend

; Calls or names one of the shared functions below, in the installer's or the
; uninstaller's copy as the code around it is.
!macro VigilCall NAME
  !ifdef __UNINSTALL__
    Call un.${NAME}
  !else
    Call ${NAME}
  !endif
!macroend
!macro VigilOnClick HWND NAME
  !ifdef __UNINSTALL__
    ${NSD_OnClick} ${HWND} un.${NAME}
  !else
    ${NSD_OnClick} ${HWND} ${NAME}
  !endif
!macroend

; ---- Controls -----------------------------------------------------------------

; OUT = a control at X, Y, W × H (pixels at 96 DPI). PARENT "dialog" puts it on
; the current nsDialogs page (so NSD_OnClick works); a window handle puts it
; on that window (a built-in page).
!macro VigilControl OUT PARENT CLASS STYLE EXSTYLE X Y W H TEXT FONT
  ${VigilScale} $R1 ${X}
  ${VigilScale} $R2 ${Y}
  ${VigilScale} $R3 ${W}
  ${VigilScale} $R4 ${H}
  !if "${PARENT}" == "dialog"
    nsDialogs::CreateControl ${CLASS} ${STYLE} ${EXSTYLE} $R1 $R2 $R3 $R4 "${TEXT}"
  !else
    System::Call 'user32::CreateWindowExW(i ${EXSTYLE}, w "${CLASS}", w "${TEXT}", i ${STYLE}, i R1, i R2, i R3, i R4, p ${PARENT}, p 0, p 0, p 0) p .s'
  !endif
  Pop ${OUT}
  !if "${FONT}" != "0"
    SendMessage ${OUT} ${WM_SETFONT} ${FONT} 1
  !endif
!macroend

; OUT = the width of TEXT in FONT, in pixels at 96 DPI.
!macro VigilTextWidth OUT TEXT FONT
  System::Call 'user32::GetDC(p 0) p .R7'
  System::Call 'gdi32::SelectObject(p R7, p ${FONT}) p .R8'
  StrLen $R9 "${TEXT}"
  System::Call '*(i, i) p .R6'
  System::Call 'gdi32::GetTextExtentPoint32W(p R7, w "${TEXT}", i R9, p R6)'
  System::Call '*$R6(i .R9)'
  System::Free $R6
  System::Call 'gdi32::SelectObject(p R7, p R8)'
  System::Call 'user32::ReleaseDC(p 0, p R7)'
  IntOp ${OUT} $R9 * 96
  IntOp ${OUT} ${OUT} / $VigilDpi
!macroend

; A line of text centered on the page.
!macro VigilText OUT PARENT Y H TEXT FONT ROLE
  !insertmacro VigilControl ${OUT} ${PARENT} STATIC ${VIGIL_TEXT} 0 24 ${Y} $VigilInner ${H} "${TEXT}" ${FONT}
  !insertmacro VigilPaint ${OUT} ${ROLE}
!macroend

; A link-colored line of text, W wide and centered at Y.
!macro VigilLink OUT Y W TEXT
  IntOp $R0 $VigilWidth - ${W}
  IntOp $R0 $R0 / 2
  !insertmacro VigilControl ${OUT} dialog STATIC ${VIGIL_TEXT} 0 $R0 ${Y} ${W} 22 "${TEXT}" $VigilFontBody
  !insertmacro VigilPaint ${OUT} link
!macroend

; A flat accent button, W × 40 (at 96 DPI) and centered: a static control
; showing a bitmap of it. ENABLED 0 draws it grayed out.
!macro VigilButton OUT Y W TEXT ENABLED
  IntOp $R0 $VigilWidth - ${W}
  IntOp $R0 $R0 / 2
  !insertmacro VigilControl ${OUT} dialog STATIC ${VIGIL_IMAGE} 0 $R0 ${Y} ${W} 40 "" 0
  Push ${OUT}
  Push "${TEXT}"
  Push ${ENABLED}
  !insertmacro VigilCall VigilDrawButton
!macroend

; A check box with its label, centered together at Y; OUT is the box. A themed
; check box draws its own text color, so the label is a separate control, and
; clicking it toggles the box.
!macro VigilCheck OUT Y TEXT CHECKED
  !insertmacro VigilTextWidth $R5 "${TEXT}" $VigilFontBody
  IntOp $R5 $R5 + 8
  IntOp $R0 $R5 + 24
  IntOp $R0 $VigilWidth - $R0
  IntOp $R0 $R0 / 2
  IntOp $R6 ${Y} + 2
  !insertmacro VigilControl ${OUT} dialog BUTTON ${VIGIL_CHECK} 0 $R0 $R6 16 18 "" 0
  !insertmacro VigilPaint ${OUT} page
  ${If} $VigilDark = 1
    System::Call 'uxtheme::SetWindowTheme(p ${OUT}, w "DarkMode_Explorer", p 0)'
  ${EndIf}
  ${If} ${CHECKED} = 1
    SendMessage ${OUT} ${BM_SETCHECK} ${BST_CHECKED} 0
  ${EndIf}
  StrCpy $VigilCheckBox ${OUT}
  IntOp $R0 $R0 + 24
  !insertmacro VigilControl $R6 dialog STATIC ${VIGIL_LABEL} 0 $R0 ${Y} $R5 22 "${TEXT}" $VigilFontBody
  !insertmacro VigilPaint $R6 ink2
  !insertmacro VigilOnClick $R6 VigilToggleCheck
!macroend

; The app icon, SIZE pixels square (at 96 DPI), centered at Y.
!macro VigilLogo OUT PARENT Y SIZE
  IntOp $R0 $VigilWidth - ${SIZE}
  IntOp $R0 $R0 / 2
  !insertmacro VigilControl ${OUT} ${PARENT} STATIC ${VIGIL_ICON} 0 $R0 ${Y} ${SIZE} ${SIZE} "" 0
  !insertmacro VigilPaint ${OUT} page
  ${VigilScale} $R6 ${SIZE}
  System::Call 'kernel32::GetModuleHandleW(p 0) p .R5'
  ; Resource 103 is the (un)installer icon, built from the app's icon.ico with all its sizes.
  System::Call 'user32::LoadImageW(p R5, i 103, i 1, i R6, i R6, i 0) p .R5'
  SendMessage ${OUT} ${STM_SETICON} $R5 0
!macroend

; ---- Shared functions -----------------------------------------------------------

!macro VigilSharedFunctions UN

Function ${UN}VigilLoadTheme
  System::Call 'user32::GetDpiForWindow(p $HWNDPARENT) i .s'
  Pop $VigilDpi
  ${If} $VigilDpi < 96
    StrCpy $VigilDpi 96
  ${EndIf}

  ClearErrors
  ReadRegDWORD $0 HKCU "Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "AppsUseLightTheme"
  ${If} ${Errors}
    StrCpy $0 1
  ${EndIf}
  ${If} $0 = 0
    StrCpy $VigilDark 1
    !insertmacro VigilColorRef $VigilBgRef ${VIGIL_DARK_BG}
    !insertmacro VigilColorRef $VigilAccentRef ${VIGIL_DARK_ACCENT}
    !insertmacro VigilColorRef $VigilOnAccentRef ${VIGIL_DARK_ON_ACCENT}
    !insertmacro VigilColorRef $VigilTrackRef ${VIGIL_DARK_TRACK}
    !insertmacro VigilColorRef $VigilInk3Ref ${VIGIL_DARK_INK3}
  ${Else}
    StrCpy $VigilDark 0
    !insertmacro VigilColorRef $VigilBgRef ${VIGIL_LIGHT_BG}
    !insertmacro VigilColorRef $VigilAccentRef ${VIGIL_LIGHT_ACCENT}
    !insertmacro VigilColorRef $VigilOnAccentRef ${VIGIL_LIGHT_ON_ACCENT}
    !insertmacro VigilColorRef $VigilTrackRef ${VIGIL_LIGHT_TRACK}
    !insertmacro VigilColorRef $VigilInk3Ref ${VIGIL_LIGHT_INK3}
  ${EndIf}

  ; GDI+ draws the buttons (anti-aliased corners).
  System::Call '*(i 1, p 0, i 0, i 0) p .r1'
  System::Call 'gdiplus::GdiplusStartup(*p .r0, p r1, p 0)'
  System::Free $1

  !insertmacro VigilFont $VigilFontHero 30 600
  !insertmacro VigilFont $VigilFontTitle 24 600
  !insertmacro VigilFont $VigilFontBody 14 400
  !insertmacro VigilFont $VigilFontSmall 12 400
  !insertmacro VigilFont $VigilFontButton 14 600
FunctionEnd

; Called once the main window exists: the wizard's header, separators,
; branding and buttons go, and the page area takes the whole window.
Function ${UN}VigilGuiInit
  Call ${UN}VigilLoadTheme
  !insertmacro VigilPaint $HWNDPARENT page

  ; Windows 11: a title bar in the page color, dark with the dark theme.
  System::Call 'dwmapi::DwmSetWindowAttribute(p $HWNDPARENT, i 20, *i $VigilDark, i 4)'
  System::Call 'dwmapi::DwmSetWindowAttribute(p $HWNDPARENT, i 35, *i $VigilBgRef, i 4)'

  ; Branding (1028, 1256), header (1034, 1037–1039) and separators (1035, 1036).
  ${ForEach} $1 1028 1039 + 1
    GetDlgItem $0 $HWNDPARENT $1
    ${If} $0 <> 0
      ShowWindow $0 ${SW_HIDE}
    ${EndIf}
  ${Next}
  GetDlgItem $0 $HWNDPARENT 1256
  ShowWindow $0 ${SW_HIDE}
  Call ${UN}VigilHideButtons

  ; One window size in every language (NSIS sizes the dialog by the language's
  ; font), kept centered where NSIS put it.
  System::Call '*(i, i, i, i) p .r1'
  System::Call 'user32::GetWindowRect(p $HWNDPARENT, p r1)'
  System::Call '*$1(i .r4, i .r5, i .r6, i .r7)'
  System::Call 'user32::GetClientRect(p $HWNDPARENT, p r1)'
  System::Call '*$1(i, i, i .r2, i .r3)'
  System::Free $1
  IntOp $6 $6 - $4 ; window size
  IntOp $7 $7 - $5
  ${VigilScale} $8 500 ; new client size
  ${VigilScale} $9 360
  IntOp $0 $6 - $2 ; plus the frame
  IntOp $0 $0 + $8
  IntOp $1 $7 - $3
  IntOp $1 $1 + $9
  IntOp $2 $6 - $0 ; recentered
  IntOp $2 $2 / 2
  IntOp $4 $4 + $2
  IntOp $3 $7 - $1
  IntOp $3 $3 / 2
  IntOp $5 $5 + $3
  System::Call 'user32::SetWindowPos(p $HWNDPARENT, p 0, i r4, i r5, i r0, i r1, i 0x14)'
  System::Call '*(i, i, i, i) p .r1'
  System::Call 'user32::GetClientRect(p $HWNDPARENT, p r1)'
  System::Call '*$1(i, i, i .r2, i .r3)'
  System::Free $1
  GetDlgItem $0 $HWNDPARENT 1018
  System::Call 'user32::SetWindowPos(p r0, p 0, i 0, i 0, i r2, i r3, i 0x14)'
  StrCpy $VigilClientWidth $2
  StrCpy $VigilClientHeight $3
  IntOp $VigilWidth $2 * 96
  IntOp $VigilWidth $VigilWidth / $VigilDpi
  IntOp $VigilHeight $3 * 96
  IntOp $VigilHeight $VigilHeight / $VigilDpi
  IntOp $VigilInner $VigilWidth - 48
FunctionEnd

; The Back, Next and Cancel buttons (3, 1, 2), which NSIS shows again on every
; page. Next stays the default button, so Enter still moves on.
Function ${UN}VigilHideButtons
  ${ForEach} $1 1 3 + 1
    GetDlgItem $0 $HWNDPARENT $1
    ShowWindow $0 ${SW_HIDE}
  ${Next}
FunctionEnd

; Draws the button bitmap for the static control on the stack (see VigilButton).
Function ${UN}VigilDrawButton
  Pop $R9 ; enabled
  Pop $R8 ; text
  Pop $R7 ; control
  Push $0
  Push $1
  Push $2
  Push $3
  Push $4
  Push $5
  Push $6
  Push $7
  Push $8
  Push $9
  ${If} $R9 = 1
    StrCpy $8 $VigilAccentRef
    StrCpy $9 $VigilOnAccentRef
  ${Else}
    StrCpy $8 $VigilTrackRef
    StrCpy $9 $VigilInk3Ref
  ${EndIf}

  System::Call '*(i, i, i, i) p .r6'
  System::Call 'user32::GetClientRect(p R7, p r6)'
  System::Call '*$6(i, i, i .r4, i .r5)'
  System::Call 'user32::GetDC(p 0) p .r0'
  System::Call 'gdi32::CreateCompatibleDC(p r0) p .r1'
  System::Call 'user32::ReleaseDC(p 0, p r0)'
  ; A top-down 24-bit bitmap: in a 32-bit one GDI's text would leave alpha 0,
  ; and the static control would blend those pixels away.
  IntOp $7 0 - $5
  System::Call '*(i 40, i r4, i r7, &i2 1, &i2 24, i 0, i 0, i 0, i 0, i 0, i 0, i 0) p .r0'
  System::Call 'gdi32::CreateDIBSection(p r1, p r0, i 0, *p .r7, p 0, i 0) p .r2'
  System::Free $0
  System::Call 'gdi32::SelectObject(p r1, p r2) p .r3'

  ; The page color around the corners.
  System::Call 'gdi32::CreateSolidBrush(i $VigilBgRef) p .r0'
  System::Call 'user32::FillRect(p r1, p r6, p r0)'
  System::Call 'gdi32::DeleteObject(p r0)'

  ; The rounded rectangle, in GDI+'s ARGB: two rectangles and four circles
  ; (System::Call cannot pass the REAL angles of a path's arcs).
  IntOp $0 $8 & 0xFF
  IntOp $0 $0 << 16
  IntOp $7 $8 & 0xFF00
  IntOp $0 $0 | $7
  IntOp $7 $8 >> 16
  IntOp $7 $7 & 0xFF
  IntOp $0 $0 | $7
  IntOp $8 $0 | 0xFF000000
  System::Call 'gdiplus::GdipCreateFromHDC(p r1, *p .r0)'
  System::Call 'gdiplus::GdipSetSmoothingMode(p r0, i 4)'
  System::Call 'gdiplus::GdipCreateSolidFill(i r8, *p .r8)'
  ${VigilScale} $R6 6 ; corner radius
  IntOp $R3 $R6 * 2
  IntOp $R4 $4 - $R3
  IntOp $R5 $5 - $R3
  System::Call 'gdiplus::GdipFillRectangleI(p r0, p r8, i R6, i 0, i R4, i r5)'
  System::Call 'gdiplus::GdipFillRectangleI(p r0, p r8, i 0, i R6, i r4, i R5)'
  System::Call 'gdiplus::GdipFillEllipseI(p r0, p r8, i 0, i 0, i R3, i R3)'
  System::Call 'gdiplus::GdipFillEllipseI(p r0, p r8, i R4, i 0, i R3, i R3)'
  System::Call 'gdiplus::GdipFillEllipseI(p r0, p r8, i 0, i R5, i R3, i R3)'
  System::Call 'gdiplus::GdipFillEllipseI(p r0, p r8, i R4, i R5, i R3, i R3)'
  System::Call 'gdiplus::GdipDeleteBrush(p r8)'
  System::Call 'gdiplus::GdipDeleteGraphics(p r0)'

  ; The label.
  System::Call 'gdi32::SelectObject(p r1, p $VigilFontButton)'
  System::Call 'gdi32::SetBkMode(p r1, i 1)'
  System::Call 'gdi32::SetTextColor(p r1, i r9)'
  System::Call 'user32::DrawTextW(p r1, w R8, i -1, p r6, i 0x25)' ; DT_CENTER | DT_VCENTER | DT_SINGLELINE

  System::Call 'gdi32::SelectObject(p r1, p r3)'
  System::Call 'gdi32::DeleteDC(p r1)'
  System::Free $6
  SendMessage $R7 ${STM_SETIMAGE} 0 $2 $0
  ${If} $0 <> 0
    System::Call 'gdi32::DeleteObject(p r0)'
  ${EndIf}
  Pop $9
  Pop $8
  Pop $7
  Pop $6
  Pop $5
  Pop $4
  Pop $3
  Pop $2
  Pop $1
  Pop $0
FunctionEnd

; Click handlers: on to the next page (past the last one, the window closes),
; and the check box's label.
Function ${UN}VigilNext
  Pop $0
  SendMessage $HWNDPARENT 0x408 1 0
FunctionEnd

Function ${UN}VigilToggleCheck
  Pop $0
  SendMessage $VigilCheckBox ${BM_GETCHECK} 0 0 $0
  ${If} $0 = ${BST_CHECKED}
    SendMessage $VigilCheckBox ${BM_SETCHECK} ${BST_UNCHECKED} 0
  ${Else}
    SendMessage $VigilCheckBox ${BM_SETCHECK} ${BST_CHECKED} 0
  ${EndIf}
FunctionEnd

; Restyles the built-in progress page, with the title on the stack.
Function ${UN}VigilStyleProgress
  Pop $6
  Call ${UN}VigilHideButtons
  FindWindow $5 "#32770" "" $HWNDPARENT
  !insertmacro VigilPaint $5 page
  ; NSIS keeps a built-in page at its template size; this one takes the window.
  System::Call 'user32::SetWindowPos(p r5, p 0, i 0, i 0, i $VigilClientWidth, i $VigilClientHeight, i 0x16)'

  ; The details list and its button stay out of sight.
  GetDlgItem $0 $5 1016
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $5 1027
  ShowWindow $0 ${SW_HIDE}

  !insertmacro VigilLogo $1 $5 70 64
  !insertmacro VigilText $1 $5 146 36 "$6" $VigilFontTitle ink

  ; A thin, flat bar in the accent color.
  GetDlgItem $0 $5 1004
  System::Call 'uxtheme::SetWindowTheme(p r0, w "", w "")'
  System::Call 'user32::GetWindowLongW(p r0, i ${GWL_STYLE}) i .r1'
  IntOp $1 $1 | ${PBS_SMOOTH}
  System::Call 'user32::SetWindowLongW(p r0, i ${GWL_STYLE}, i r1)'
  System::Call 'user32::SetWindowLongW(p r0, i ${GWL_EXSTYLE}, i 0)'
  SendMessage $0 ${PBM_SETBARCOLOR} 0 $VigilAccentRef
  SendMessage $0 ${PBM_SETBKCOLOR} 0 $VigilTrackRef
  IntOp $1 $VigilWidth * 15
  IntOp $1 $1 / 100
  IntOp $2 $VigilWidth * 70
  IntOp $2 $2 / 100
  ${VigilScale} $1 $1
  ${VigilScale} $2 $2
  ${VigilScale} $3 200
  ${VigilScale} $4 4
  System::Call 'user32::SetWindowPos(p r0, p 0, i r1, i r3, i r2, i r4, i 0x34)'

  ; What it is doing, under the bar.
  GetDlgItem $0 $5 1006
  SendMessage $0 ${WM_SETFONT} $VigilFontSmall 1
  !insertmacro VigilPaint $0 ink3
  System::Call 'user32::GetWindowLongW(p r0, i ${GWL_STYLE}) i .r1'
  ; The low five bits are the static's type (here SS_LEFTNOWORDWRAP); OR-ing
  ; SS_CENTER into it would make it owner-drawn.
  IntOp $1 $1 & 0xFFFFFFE0
  IntOp $1 $1 | ${SS_CENTER}
  IntOp $1 $1 | ${SS_PATHELLIPSIS}
  System::Call 'user32::SetWindowLongW(p r0, i ${GWL_STYLE}, i r1)'
  ${VigilScale} $1 24
  ${VigilScale} $2 $VigilInner
  ${VigilScale} $3 216
  ${VigilScale} $4 20
  System::Call 'user32::SetWindowPos(p r0, p 0, i r1, i r3, i r2, i r4, i 0x34)'
FunctionEnd

!macroend
!insertmacro VigilSharedFunctions ""
!insertmacro VigilSharedFunctions "un."

; ---- Installer: install or upgrade ------------------------------------------------

Var VigilOldVersion
Var VigilCompare ; 2: not installed; 1: upgrade; 0: same version; -1: newer installed
Var VigilLocationText

Function VigilDetect
  StrCpy $VigilCompare 2
  ReadRegStr $VigilOldVersion SHCTX "${UNINSTKEY}" "DisplayVersion"
  ReadRegStr $0 SHCTX "${UNINSTKEY}" "UninstallString"
  ${If} $0 != ""
    ${If} $VigilOldVersion == ""
      StrCpy $VigilCompare 1
    ${Else}
      nsis_tauri_utils::SemverCompare "${VERSION}" $VigilOldVersion
      Pop $VigilCompare
    ${EndIf}
  ${EndIf}
FunctionEnd

Function VigilPageMain
  Call VigilDetect
  ${IfThen} $PassiveMode = 1 ${|} Abort ${|}

  nsDialogs::Create 1018
  Pop $0
  !insertmacro VigilPaint $0 page

  !insertmacro VigilLogo $1 dialog 34 64
  !insertmacro VigilText $1 dialog 108 44 "${PRODUCTNAME}" $VigilFontHero ink
  !insertmacro VigilText $1 dialog 154 22 "$(VigilTagline)" $VigilFontBody ink2

  ${If} $VigilCompare = 1
    StrCpy $6 "$(VigilUpgradeFrom)"
    StrCpy $7 "$(VigilUpgrade)"
  ${ElseIf} $VigilCompare = 0
    StrCpy $6 "$(VigilSameVersion)"
    StrCpy $7 "$(VigilReinstall)"
  ${ElseIf} $VigilCompare = -1
    StrCpy $6 "$(VigilNewerInstalled)"
    StrCpy $7 "$(VigilInstall)"
  ${Else}
    StrCpy $6 "$(VigilVersion)"
    StrCpy $7 "$(VigilInstall)"
  ${EndIf}
  !insertmacro VigilText $1 dialog 180 36 "$6" $VigilFontSmall ink3

  ${If} $VigilCompare = -1
    StrCpy $2 0
  ${Else}
    StrCpy $2 1
  ${EndIf}
  !insertmacro VigilButton $1 226 176 "$7" $2
  ${If} $2 = 1
    ${NSD_OnClick} $1 VigilNext
  ${EndIf}

  ; Bottom line: where it goes and, for a new install, a way to change it.
  IntOp $2 $VigilHeight - 40
  IntOp $3 $VigilWidth - 120
  !insertmacro VigilControl $VigilLocationText dialog STATIC ${VIGIL_PATH} 0 24 $2 $3 20 "$(VigilLocation)" $VigilFontSmall
  !insertmacro VigilPaint $VigilLocationText ink3
  ${If} $VigilCompare = 2
    IntOp $3 $VigilWidth - 88
    !insertmacro VigilControl $1 dialog STATIC ${VIGIL_LABEL} 0 $3 $2 64 20 "$(VigilChange)" $VigilFontSmall
    !insertmacro VigilPaint $1 link
    ${NSD_OnClick} $1 VigilChangeLocation
  ${EndIf}

  Call VigilHideButtons
  nsDialogs::Show
FunctionEnd

Function VigilPageMainLeave
  ; A newer version blocks the button; Enter must not get past it either.
  ${IfThen} $VigilCompare = -1 ${|} Abort ${|}
FunctionEnd

Function VigilChangeLocation
  Pop $0
  nsDialogs::SelectFolderDialog "$(VigilChooseFolder)" $INSTDIR
  Pop $0
  ${If} $0 != error
  ${AndIf} $0 != ""
    ; Like the directory page: a chosen parent folder gets a folder of its own.
    StrLen $1 "${PRODUCTNAME}"
    IntOp $1 0 - $1
    StrCpy $2 $0 "" $1
    ${If} $2 != "${PRODUCTNAME}"
      StrCpy $0 "$0\${PRODUCTNAME}"
    ${EndIf}
    StrCpy $INSTDIR $0
    SendMessage $VigilLocationText ${WM_SETTEXT} 0 "STR:$(VigilLocation)"
  ${EndIf}
FunctionEnd

Function VigilPageProgress
  ${If} $UpdateMode = 1
  ${OrIf} $VigilCompare = 1
    Push "$(VigilUpdating)"
  ${Else}
    Push "$(VigilInstalling)"
  ${EndIf}
  Call VigilStyleProgress
FunctionEnd

; ---- Installer: finish ---------------------------------------------------------

Var VigilLaunchApp

Function VigilPageFinish
  ${IfThen} $PassiveMode = 1 ${|} Abort ${|}

  nsDialogs::Create 1018
  Pop $0
  !insertmacro VigilPaint $0 page
  StrCpy $VigilLaunchApp 1

  !insertmacro VigilLogo $1 dialog 34 64
  !insertmacro VigilText $1 dialog 110 36 "$(VigilInstalled)" $VigilFontTitle ink
  !insertmacro VigilText $1 dialog 150 22 "$(VigilInstalledText)" $VigilFontBody ink2
  ${If} $UpdateMode = 1
    StrCpy $2 0
  ${Else}
    StrCpy $2 1
  ${EndIf}
  !insertmacro VigilCheck $1 185 "$(VigilDesktopShortcut)" $2
  !insertmacro VigilButton $1 228 176 "$(VigilLaunch)" 1
  ${NSD_OnClick} $1 VigilNext
  !insertmacro VigilLink $1 280 80 "$(VigilClose)"
  ${NSD_OnClick} $1 VigilCloseOnly

  Call VigilHideButtons
  nsDialogs::Show
FunctionEnd

Function VigilCloseOnly
  Pop $0
  StrCpy $VigilLaunchApp 0
  SendMessage $HWNDPARENT 0x408 1 0
FunctionEnd

Function VigilPageFinishLeave
  SendMessage $VigilCheckBox ${BM_GETCHECK} 0 0 $0
  ${If} $0 = ${BST_CHECKED}
    Call CreateOrUpdateDesktopShortcut
  ${EndIf}
  ${If} $VigilLaunchApp = 1
    Call RunMainBinary
  ${EndIf}
FunctionEnd

; ---- Uninstaller ----------------------------------------------------------------

Function un.VigilPageConfirm
  ${IfThen} $PassiveMode = 1 ${|} Abort ${|}

  nsDialogs::Create 1018
  Pop $0
  !insertmacro VigilPaint $0 page

  !insertmacro VigilLogo $1 dialog 34 64
  !insertmacro VigilText $1 dialog 110 36 "$(VigilUninstallTitle)" $VigilFontTitle ink
  !insertmacro VigilText $1 dialog 150 22 "$(VigilUninstallText)" $VigilFontBody ink2
  !insertmacro VigilCheck $1 185 "$(VigilDeleteData)" 0
  !insertmacro VigilButton $1 228 176 "$(VigilUninstall)" 1
  ${NSD_OnClick} $1 un.VigilNext
  !insertmacro VigilLink $1 280 80 "$(VigilCancel)"
  ${NSD_OnClick} $1 un.VigilQuit

  Call un.VigilHideButtons
  nsDialogs::Show
FunctionEnd

Function un.VigilPageConfirmLeave
  ; Read by the Uninstall section.
  SendMessage $VigilCheckBox ${BM_GETCHECK} 0 0 $DeleteAppDataCheckboxState
  ; Straight on to the done page once the files are gone.
  SetAutoClose true
FunctionEnd

Function un.VigilQuit
  Pop $0
  Quit
FunctionEnd

Function un.VigilPageProgress
  Push "$(VigilUninstalling)"
  Call un.VigilStyleProgress
FunctionEnd

Function un.VigilPageDone
  ${If} $PassiveMode = 1
  ${OrIf} $UpdateMode = 1
    Abort
  ${EndIf}

  nsDialogs::Create 1018
  Pop $0
  !insertmacro VigilPaint $0 page

  !insertmacro VigilLogo $1 dialog 34 64
  !insertmacro VigilText $1 dialog 110 36 "$(VigilUninstalled)" $VigilFontTitle ink
  !insertmacro VigilText $1 dialog 150 22 "$(VigilUninstalledText)" $VigilFontBody ink2
  !insertmacro VigilButton $1 228 176 "$(VigilClose)" 1
  ${NSD_OnClick} $1 un.VigilNext

  Call un.VigilHideButtons
  nsDialogs::Show
FunctionEnd
