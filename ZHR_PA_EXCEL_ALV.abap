*&---------------------------------------------------------------------*
*& Report  ZHR_PA_EXCEL_ALV
*&---------------------------------------------------------------------*
*& Beschreibung: Excel Import -> Datenvalidierung -> OO-ALV mit Buttons
*&
*& Include Structure:
*&   ZHR_PA_EXCEL_ALV_TOP    - Datendefinitionen
*&   ZHR_PA_EXCEL_ALV_SEL    - Selektionsdaten
*&   ZHR_PA_EXCEL_ALV_F01    - Excel Import Routinen
*&   ZHR_PA_EXCEL_ALV_F02    - Datenvalidierung Routinen
*&   ZHR_PA_EXCEL_ALV_F03    - ALV Display Routinen
*&   ZHR_PA_EXCEL_ALV_F04    - Event Handler & Zeilenbearbeitung
*&---------------------------------------------------------------------*

REPORT zhr_pa_excel_alv.

*----------- Includes einbinden -----------
INCLUDE zhr_pa_excel_alv_top.    " Datendefinitionen
INCLUDE zhr_pa_excel_alv_sel.    " Selektionsdaten

*&---------------------------------------------------------------------*
*& START-OF-SELECTION
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  IF p_file IS INITIAL.
    MESSAGE e000(00) WITH 'Bitte Excel Datei auswählen!'.
  ENDIF.

  PERFORM read_excel.
  PERFORM validate_data.
  PERFORM display_alv.

*&---------------------------------------------------------------------*
*& END-OF-SELECTION
*&---------------------------------------------------------------------*
END-OF-SELECTION.

*----------- Perform Includes einbinden -----------
INCLUDE zhr_pa_excel_alv_f01.    " Excel Import Routinen
INCLUDE zhr_pa_excel_alv_f02.    " Datenvalidierung Routinen
INCLUDE zhr_pa_excel_alv_f03.    " ALV Display Routinen
INCLUDE zhr_pa_excel_alv_f04.    " Event Handler & Zeilenbearbeitung
