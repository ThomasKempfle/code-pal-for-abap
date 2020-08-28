CLASS y_unit_test_base DEFINITION PUBLIC ABSTRACT FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.
  PUBLIC SECTION.
    METHODS bound FOR TESTING.
    METHODS issue FOR TESTING.
    METHODS no_issue FOR TESTING.
    METHODS exmeption FOR TESTING.
  PROTECTED SECTION.
    METHODS get_cut ABSTRACT RETURNING VALUE(result) TYPE REF TO y_check_base.
    METHODS get_code_with_issue ABSTRACT RETURNING VALUE(result) TYPE char255_tab.
    METHODS get_code_without_issue ABSTRACT RETURNING VALUE(result) TYPE char255_tab.
    METHODS get_code_with_exemption ABSTRACT RETURNING VALUE(result) TYPE char255_tab.
  PRIVATE SECTION.
    DATA cut TYPE REF TO y_check_base.
    METHODS setup.
    METHODS given_code_with_issue.
    METHODS given_code_without_issue.
    METHODS given_code_with_exemption.
    METHODS when_run.
    METHODS then_issue.
    METHODS then_no_issue.
    METHODS then_exemption.
    METHODS then_no_exemption.
    METHODS get_issue_count RETURNING VALUE(result) TYPE i.
ENDCLASS.


CLASS y_unit_test_base IMPLEMENTATION.

  METHOD bound.
    cl_abap_unit_assert=>assert_bound(  cut ).
  ENDMETHOD.

  METHOD issue.
    given_code_with_issue( ).
    when_run( ).
    then_issue( ).
    then_no_exemption( ).
  ENDMETHOD.

  METHOD no_issue.
    given_code_without_issue( ).
    when_run( ).
    then_no_issue( ).
    then_no_exemption( ).
  ENDMETHOD.

  METHOD exmeption.
    given_code_with_exemption( ).
    when_run( ).
    then_no_issue( ).
    then_exemption( ).
  ENDMETHOD.

  METHOD setup.
    cut ?= get_cut( ).
    cut->object_name = cl_abap_objectdescr=>describe_by_object_ref( cut )->get_relative_name( ).
    cut->object_type = 'CLAS'.
    cut->attributes_maintained = abap_true.
    cut->ref_scan_manager ?= NEW y_ref_scan_manager_double(  ).
    cut->clean_code_manager = NEW y_clean_code_manager_double( cut ).
  ENDMETHOD.

  METHOD given_code_without_issue.
    CAST y_ref_scan_manager_double( cut->ref_scan_manager )->inject_code( get_code_without_issue(  ) ).
  ENDMETHOD.

  METHOD given_code_with_exemption.
    CAST y_ref_scan_manager_double( cut->ref_scan_manager )->inject_code( get_code_with_exemption(  ) ).
  ENDMETHOD.

  METHOD given_code_with_issue.
    CAST y_ref_scan_manager_double( cut->ref_scan_manager )->inject_code( get_code_with_issue(  ) ).
  ENDMETHOD.

  METHOD when_run.
    cut->run( ).
  ENDMETHOD.

  METHOD then_issue.
    cl_abap_unit_assert=>assert_equals( act = get_issue_count( )
                                        exp = 1 ).
  ENDMETHOD.

  METHOD then_no_issue.
    cl_abap_unit_assert=>assert_initial( get_issue_count( ) ).
  ENDMETHOD.

  METHOD then_exemption.
    cl_abap_unit_assert=>assert_equals( act = cut->statistics->get_number_pseudo_comments( )
                                        exp = 1 ).
  ENDMETHOD.

  METHOD then_no_exemption.
    cl_abap_unit_assert=>assert_initial( cut->statistics->get_number_pseudo_comments( ) ).
  ENDMETHOD.

  METHOD get_issue_count.
    result = COND #( WHEN cut->settings-prio = y_check_base=>c_error THEN cut->statistics->get_number_errors( )
                     WHEN cut->settings-prio = y_check_base=>c_warning THEN cut->statistics->get_number_warnings( )
                     WHEN cut->settings-prio = y_check_base=>c_info THEN cut->statistics->get_number_notes( ) ).
  ENDMETHOD.

ENDCLASS.