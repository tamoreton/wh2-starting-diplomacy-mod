function hamskii_script()
    if cm:is_new_game() then
        -- call your script functions here that you only want to run at the start of a campaign.
        output("==========HAMSKII MOD IS ACTIVE==========");
        -- Empire
        cm:force_make_vassal("wh_main_emp_empire", "wh_main_emp_middenland");
        cm:force_make_vassal("wh_main_emp_empire", "wh_main_emp_averland");
        cm:force_make_vassal("wh_main_emp_empire", "wh_main_emp_talabecland");
        cm:force_make_vassal("wh_main_emp_empire", "wh_main_emp_ostland");
        cm:force_make_vassal("wh_main_emp_empire", "wh_main_emp_nordland");
        cm:force_make_vassal("wh_main_emp_empire", "wh_main_emp_hochland");
        cm:force_make_vassal("wh_main_emp_empire", "wh_main_emp_ostermark");
        cm:force_make_vassal("wh_main_emp_empire", "wh_main_emp_stirland");
        cm:force_make_vassal("wh_main_emp_empire", "wh_main_emp_wissenland");

        -- Dwarfs
        cm:force_make_vassal("wh_main_dwf_dwarfs", "wh_main_dwf_barak_varr");
        cm:force_make_vassal("wh_main_dwf_dwarfs", "wh_main_dwf_karak_azul");
        cm:force_make_vassal("wh_main_dwf_dwarfs", "wh_main_dwf_karak_hirn");
        cm:force_make_vassal("wh_main_dwf_dwarfs", "wh_main_dwf_karak_izor"); -- Clan Angrund
        cm:force_make_vassal("wh_main_dwf_dwarfs", "wh_main_dwf_karak_kadrin");
        cm:force_make_vassal("wh_main_dwf_dwarfs", "wh_main_dwf_karak_norn");
        cm:force_make_vassal("wh_main_dwf_dwarfs", "wh_main_dwf_karak_ziflin");
        cm:force_diplomacy_new("wh_main_dwf_dwarfs", "wh_main_dwf_kraka_drak", "non aggression pact", true, true, true);
        cm:force_diplomacy_new("wh_main_dwf_dwarfs", "wh_main_dwf_kraka_drak", "soft military access", true, true, true);
        cm:force_diplomacy_new("wh_main_dwf_dwarfs", "wh_main_dwf_kraka_drak", "trade agreement", true, true, true);
        cm:force_make_vassal("wh_main_dwf_dwarfs", "wh_main_dwf_zhufbar");
        cm:force_make_vassal("wh_main_dwf_dwarfs", "wh2_main_dwf_greybeards_prospectors");
        cm:force_make_vassal("wh_main_dwf_dwarfs", "wh2_main_dwf_spine_of_sotek_dwarfs");
    else
        -- call functions here that you want to fire every time you load the game.
    end;
end;