*&---------------------------------------------------------------------*
*& Include ZHR_PA_EXCEL_ALV_F04
*&---------------------------------------------------------------------*
*& Performroutinen für Event Handler und Zeilenbearbeitung
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& FORM handle_button_click
*&---------------------------------------------------------------------*
FORM handle_button_click USING l_ucomm TYPE sy-ucomm
                               ls_selfield TYPE lvc_s_selfield.

  DATA: l_row_index TYPE i.

  CASE l_ucomm.
    WHEN 'EDIT_ROW'.
      " Zeileneditierung
      PERFORM edit_row USING ls_selfield-row_index.

    WHEN 'DELETE_ROW'.
      " Zeile löschen
      PERFORM delete_row USING ls_selfield-row_index.

  ENDCASE.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM edit_row
*&---------------------------------------------------------------------*
FORM edit_row USING l_row_index TYPE i.
  DATA: ls_data TYPE ty_data.

  IF l_row_index > 0 AND l_row_index <= lines( gt_data ).
    READ TABLE gt_data INTO ls_data INDEX l_row_index.

    IF sy-subrc EQ 0.
      PERFORM show_edit_dialog USING ls_data.
      MODIFY gt_data FROM ls_data INDEX l_row_index.

      CALL METHOD g_alv_grid->refresh_table_display
        EXPORTING i_soft_refresh = abap_true.
    ENDIF.
  ELSE.
    MESSAGE i000(00) WITH 'Bitte wählen Sie eine Zeile aus.'.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM show_edit_dialog
*&---------------------------------------------------------------------*
FORM show_edit_dialog USING ls_data TYPE ty_data.
  DATA: l_answer TYPE c.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar      = 'Zeile bearbeiten'
      text_question = 'Material: ' && ls_data-matnr
    IMPORTING
      answer        = l_answer.

  IF l_answer EQ '1'.
    " Hier könnte ein Dialog zum Bearbeiten geöffnet werden
    MESSAGE i000(00) WITH 'Zeile bearbeitet: ' ls_data-matnr.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM delete_row
*&---------------------------------------------------------------------*
FORM delete_row USING l_row_index TYPE i.
  DATA: l_answer TYPE c.

  IF l_row_index > 0 AND l_row_index <= lines( gt_data ).
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar      = 'Zeile löschen?'
        text_question = 'Möchten Sie diese Zeile wirklich löschen?'
      IMPORTING
        answer        = l_answer.

    IF l_answer EQ '1'.
      DELETE gt_data INDEX l_row_index.

      CALL METHOD g_alv_grid->refresh_table_display
        EXPORTING i_soft_refresh = abap_true.

      MESSAGE i000(00) WITH 'Zeile gelöscht'.
    ENDIF.
  ELSE.
    MESSAGE i000(00) WITH 'Bitte wählen Sie eine Zeile aus.'.
  ENDIF.

ENDFORM.
