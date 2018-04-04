function hamskii_script()
    if cm:is_new_game() then
        -- call your script functions here that you only want to run at the start of a campaign.
        output("==========HAMSKII MOD IS ACTIVE==========");
        -- Empire Provinces
        cm:force_make_vassal("wh_main_emp_empire", "wh_main_emp_middenland");
        cm:force_make_vassal("wh_main_emp_empire", "wh_main_emp_averland");
        cm:force_make_vassal("wh_main_emp_empire", "wh_main_emp_talabecland");
        cm:force_make_vassal("wh_main_emp_empire", "wh_main_emp_ostland");
        cm:force_make_vassal("wh_main_emp_empire", "wh_main_emp_nordland");
        cm:force_make_vassal("wh_main_emp_empire", "wh_main_emp_hochland");
        cm:force_make_vassal("wh_main_emp_empire", "wh_main_emp_ostermark");
        cm:force_make_vassal("wh_main_emp_empire", "wh_main_emp_stirland");
        cm:force_make_vassal("wh_main_emp_empire", "wh_main_emp_wissenland");

        -- Dwarf Realms
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

        -- TODO: Greenskin Tribes

        -- Vampire Counts
        cm:force_declare_war("wh_main_vmp_schwartzhafen", "wh_main_vmp_rival_sylvanian_vamps"); -- Von Carstein
        cm:transfer_region_to_faction("wh_main_eastern_sylvania_eschen", "wh_main_vmp_vampire_counts");
        cm:transfer_region_to_faction("wh_main_eastern_sylvania_waldenhof", "wh_main_vmp_vampire_counts");
        cm:transfer_region_to_faction("wh_main_western_sylvania_castle_templehof", "wh_main_vmp_schwartzhafen");
        cm:transfer_region_to_faction("wh_main_western_sylvania_fort_oberstyre", "wh_main_vmp_schwartzhafen");
        cm:force_make_vassal("wh_main_vmp_schwartzhafen", "wh_main_vmp_mousillon");

        -- TODO: Warriors of Chaos

        -- TODO: Beastmen

        -- Wood Elves
        cm:force_make_vassal("wh_dlc05_wef_wood_elves", "wh_dlc05_wef_argwylon");
        cm:force_make_vassal("wh_dlc05_wef_wood_elves", "wh_dlc05_wef_torgovann");
        cm:force_make_vassal("wh_dlc05_wef_wood_elves", "wh_dlc05_wef_wydrioth");

        -- Bretonnian Kingdoms
        cm:force_make_vassal("wh_main_brt_bretonnia", "wh_main_brt_bordeleaux");
        cm:force_make_vassal("wh_main_brt_bretonnia", "wh_main_brt_carcassonne");
        cm:force_make_vassal("wh_main_brt_bretonnia", "wh_main_brt_artois");
        cm:force_make_vassal("wh_main_brt_bretonnia", "wh_main_brt_bastonne");
        cm:force_make_vassal("wh_main_brt_bretonnia", "wh_main_brt_lyonesse");
        cm:force_make_vassal("wh_main_brt_bretonnia", "wh_main_brt_parravon");
        cm:force_make_vassal("wh_main_brt_bretonnia", "wh2_main_brt_knights_of_origo");
        cm:force_make_vassal("wh_main_brt_bretonnia", "wh2_main_brt_knights_of_the_flame");
        cm:force_make_vassal("wh_main_brt_bretonnia", "wh2_main_brt_thegans_crusaders");        

        -- TODO: Norscan Tribes

        -- TODO: Kislev

        -- TODO: Southern Realms

        -- High Elves
        -- Not sure whether this should be wh2_main_hef_high_elves or wh2_main_hef_eataine
        cm:force_make_trade_agreement("wh2_main_hef_high_elves", "wh2_main_hef_avelorn");
        cm:force_make_trade_agreement("wh2_main_hef_high_elves", "wh2_main_hef_caledor");
        cm:force_make_trade_agreement("wh2_main_hef_high_elves", "wh2_main_hef_chrace");
        cm:force_make_trade_agreement("wh2_main_hef_high_elves", "wh2_main_hef_cothique");
        cm:force_make_trade_agreement("wh2_main_hef_high_elves", "wh2_main_hef_ellyrion");
        cm:force_make_trade_agreement("wh2_main_hef_high_elves", "wh2_main_hef_nagarythe");
        cm:force_make_trade_agreement("wh2_main_hef_high_elves", "wh2_main_hef_saphery");
        cm:force_make_trade_agreement("wh2_main_hef_high_elves", "wh2_main_hef_tiranoc");
        cm:force_make_trade_agreement("wh2_main_hef_high_elves", "wh2_main_hef_yvresse");
        cm:force_make_vassal("wh2_main_hef_saphery", "wh2_main_hef_order_of_loremasters");  


        -- TODO: Dark Elves

        -- TODO: Lizardmen

        -- TODO: Skaven

        -- TODO: Tomb Kings
    else
        -- call functions here that you want to fire every time you load the game.
    end;
end;