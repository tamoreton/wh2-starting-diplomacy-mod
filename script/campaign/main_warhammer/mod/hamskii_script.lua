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
        cm:force_make_trade_agreement("wh_main_dwf_dwarfs", "wh_main_dwf_kraka_drak");
        cm:force_make_vassal("wh_main_dwf_dwarfs", "wh_main_dwf_zhufbar");
        cm:force_make_vassal("wh_main_dwf_dwarfs", "wh2_main_dwf_greybeards_prospectors");

        -- TODO: Greenskins

        -- Vampire Counts
        cm:force_declare_war("wh_main_vmp_schwartzhafen", "wh_main_vmp_rival_sylvanian_vamps"); -- Von Carstein
        cm:transfer_region_to_faction("wh_main_eastern_sylvania_eschen", "wh_main_vmp_vampire_counts");
        cm:transfer_region_to_faction("wh_main_eastern_sylvania_waldenhof", "wh_main_vmp_vampire_counts");
        cm:transfer_region_to_faction("wh_main_western_sylvania_castle_templehof", "wh_main_vmp_schwartzhafen");
        cm:transfer_region_to_faction("wh_main_western_sylvania_fort_oberstyre", "wh_main_vmp_schwartzhafen");
        cm:force_make_vassal("wh_main_vmp_schwartzhafen", "wh_main_vmp_mousillon");

        -- TODO: Warriors of Chaos

        -- TODO: Beastmen

        -- TODO: Wood Elves

        -- TODO: Bretonnia

        -- TODO: Norsca

        -- TODO: Lizardmen

        -- TODO: Dark Elves

        -- TODO: High Elves

        -- TODO: Skaven

        -- TODO: Tomb Kings
    else
        -- call functions here that you want to fire every time you load the game.
    end;
end;