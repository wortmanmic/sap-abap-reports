*&---------------------------------------------------------------------*
*& Include ZHR_PA_EXCEL_ALV_F02
*&---------------------------------------------------------------------*
*& Performroutinen für Datenvalidierung
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& FORM validate_data
*&---------------------------------------------------------------------*
FORM validate_data.
  DATA: l_message TYPE string.

  CLEAR gt_data.

  LOOP AT gt_excel_raw INTO gs_excel_raw.
    CLEAR gs_data.

    " Daten aus Excel-Raw in strukturierte Tabelle übernehmen
    gs_data-matnr = gs_excel_raw-col1.
    gs_data-maktx = gs_excel_raw-col2.
    gs_data-meins = gs_excel_raw-col3.
    gs_data-netpr = gs_excel_raw-col4.
    gs_data-status = 'OK'.
    CLEAR gs_data-message.

    " ========== DATENVALIDIERUNG ==========
    
    " 1. Materialnummer prüfen
    PERFORM validate_matnr.

    " 2. Materialname prüfen
    PERFORM validate_maktx.

    " 3. Mengeneinheit prüfen
    PERFORM validate_meins.

    " 4. Netto-Preis prüfen
    PERFORM validate_netpr.

    " Fehlermeldung aufräumen (letztes " / " entfernen)
    IF gs_data-message IS NOT INITIAL.
      gs_data-message = gs_data-message(
        strlen( gs_data-message ) - 2
      ).
    ENDIF.

    APPEND gs_data TO gt_data.
  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM validate_matnr
*&---------------------------------------------------------------------*
FORM validate_matnr.

  IF gs_data-matnr IS INITIAL.
    gs_data-status = 'FEHLER'.
    CONCATENATE gs_data-message
                'Materialnummer fehlt / '
                INTO gs_data-message.
  ELSE.
    " Prüfen, ob Material in SAP existiert
    SELECT SINGLE matnr
      INTO gs_data-matnr
      FROM mara
      WHERE matnr = gs_data-matnr.

    IF sy-subrc NE 0.
      gs_data-status = 'FEHLER'.
      CONCATENATE gs_data-message
                  'Material nicht gefunden / '
                  INTO gs_data-message.
    ENDIF.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM validate_maktx
*&---------------------------------------------------------------------*
FORM validate_maktx.

  IF gs_data-maktx IS INITIAL.
    gs_data-status = 'FEHLER'.
    CONCATENATE gs_data-message
                'Materialname fehlt / '
                INTO gs_data-message.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM validate_meins
*&---------------------------------------------------------------------*
FORM validate_meins.

  IF gs_data-meins IS INITIAL.
    gs_data-status = 'FEHLER'.
    CONCATENATE gs_data-message
                'Mengeneinheit fehlt / '
                INTO gs_data-message.
  ELSE.
    SELECT SINGLE msehi
      INTO gs_data-meins
      FROM t006
      WHERE msehi = gs_data-meins.

    IF sy-subrc NE 0.
      gs_data-status = 'FEHLER'.
      CONCATENATE gs_data-message
                  'Mengeneinheit ungültig / '
                  INTO gs_data-message.
    ENDIF.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM validate_netpr
*&---------------------------------------------------------------------*
FORM validate_netpr.

  IF gs_data-netpr IS INITIAL OR gs_data-netpr < 0.
    gs_data-status = 'FEHLER'.
    CONCATENATE gs_data-message
                'Netto-Preis ungültig / '
                INTO gs_data-message.
  ENDIF.

ENDFORM.
