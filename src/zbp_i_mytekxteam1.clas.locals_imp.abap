CLASS lhc_MYTEKXTeam DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR MYTEKXTeam RESULT result.

    METHODS setActive FOR MODIFY
      IMPORTING keys FOR ACTION MYTEKXTeam~setActive RESULT result.

    METHODS changeSalary FOR DETERMINE ON SAVE
      IMPORTING keys FOR MYTEKXTeam~changeSalary.

    METHODS validateAge FOR VALIDATE ON SAVE
      IMPORTING keys FOR MYTEKXTeam~validateAge.

ENDCLASS.

CLASS lhc_MYTEKXTeam IMPLEMENTATION.

  METHOD get_instance_features.

  " Read the active flag of the existing members
    READ ENTITIES OF zi_mytekxteam1 IN LOCAL MODE
        ENTITY MYTEKXTeam
          FIELDS ( Active ) WITH CORRESPONDING #( keys )
        RESULT DATA(members)
        FAILED failed.

    result =
      VALUE #(
        FOR member IN members

            LET status =   COND #( WHEN member-Active = abap_true
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled  )

                                      IN


            ( %tky                 = member-%tky
              %action-setActive = status
             ) ).

  ENDMETHOD.

  METHOD setActive.

   " Do background check
    " Check references
    " Onboard member

    MODIFY ENTITIES OF zi_mytekxteam1 IN LOCAL MODE
        ENTITY MYTEKXTeam
          UPDATE
            FIELDS (  Active )
            WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             Active = abap_true

                             ) )

       FAILED failed
       REPORTED reported.


    " Fill the response table
    READ ENTITIES OF zi_mytekxteam1 IN LOCAL MODE
      ENTITY MYTEKXTeam
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(members).

    result = VALUE #( FOR member IN members
                        ( %tky   = member-%tky
                          %param = member ) ).

  ENDMETHOD.

  METHOD changeSalary.

  " Read relevant UXTeam instance data
    READ ENTITIES OF zi_mytekxteam1 IN LOCAL MODE
      ENTITY MYTEKXTeam
        FIELDS ( Role ) WITH CORRESPONDING #( keys )
      RESULT DATA(members).

    LOOP AT members INTO DATA(member).

      IF member-Role = 'ABAP Developer'.

        " Change salary to hard coded value
        MODIFY ENTITIES OF zi_mytekxteam1 IN LOCAL MODE
        ENTITY MYTEKXTeam
          UPDATE
            FIELDS ( Salary )
            WITH VALUE #(
                          ( %tky         = member-%tky
                            Salary = 7000
                            ) ).

      ENDIF.

      IF member-Role = 'TEAM Lead'.

        " Change salary to hard coded value
        MODIFY ENTITIES OF zi_mytekxteam1 IN LOCAL MODE
        ENTITY MYTEKXTeam
          UPDATE
            FIELDS ( Salary )
            WITH VALUE #(
                          ( %tky         = member-%tky
                            Salary = 9000
                            ) ).

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD validateAge.

  READ ENTITIES OF zi_mytekxteam1 IN LOCAL MODE
        ENTITY MYTEKXTeam
          FIELDS ( Age ) WITH CORRESPONDING #( keys )
        RESULT DATA(members).


    LOOP AT members INTO DATA(member).

      IF member-Age < 21.
        APPEND VALUE #( %tky = member-%tky ) TO failed-mytekxteam.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
