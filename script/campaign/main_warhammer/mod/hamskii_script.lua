-- TODO: Vassalisation function that simulates vassalisation calling force_make_vassal, forcing a
-- trade agreement if one is available, and then looping through the vassalised factions to force
-- each vassalised faction to make peace with any faction that the new master is not already at war with.
-- Have a flag on the function that, if set, causes the parent faction to declare war on the 
-- enemy of the vassalised faction instead.
-- N.B. it might be worth making sure that other vassals also declare war/make peace when the
-- force_declare_war or force_make_peace functions are called.
-- of making peace.
-- TODO: Check existing scripts to see how vassalisation is already handled.
-- TODO: Check existing scripts to see how military alliances work.

function hamskii_script()
    if cm:is_new_game() then
        -- call your script functions here that you only want to run at the start of a campaign.
        output("==== hamskii's Loreful Empires mod ====");
        output("#### Empire Provinces ####");
        cm:make_region_seen_in_shroud("wh_main_the_wasteland_gorssel", "wh_main_emp_empire");
        cm:make_region_seen_in_shroud("wh_main_the_wasteland_marienburg", "wh_main_emp_empire");
        cm:force_make_vassal("wh_main_emp_empire", "wh_main_emp_middenland");
        cm:force_make_vassal("wh_main_emp_empire", "wh_main_emp_averland");
        cm:force_make_vassal("wh_main_emp_empire", "wh_main_emp_talabecland");
        cm:force_make_vassal("wh_main_emp_empire", "wh_main_emp_ostland");
        cm:force_make_vassal("wh_main_emp_empire", "wh_main_emp_nordland");
        cm:force_make_vassal("wh_main_emp_empire", "wh_main_emp_hochland");
        cm:force_make_vassal("wh_main_emp_empire", "wh_main_emp_ostermark");
        cm:force_make_vassal("wh_main_emp_empire", "wh_main_emp_stirland");
        cm:force_make_vassal("wh_main_emp_empire", "wh_main_emp_wissenland");

        output("#### Dwarf Realms ####");
        cm:make_region_seen_in_shroud("wh_main_dwf_dwarfs", "wh_main_gianthome_mountains_khazid_bordkarag");
        cm:make_region_seen_in_shroud("wh_main_dwf_dwarfs", "wh_main_gianthome_mountains_kraka_drak");
        cm:make_region_seen_in_shroud("wh_main_dwf_dwarfs", "wh_main_gianthome_mountains_sjoktraken");
        cm:force_make_vassal("wh_main_dwf_dwarfs", "wh_main_dwf_barak_varr");
        cm:force_make_vassal("wh_main_dwf_dwarfs", "wh_main_dwf_karak_azul");
        cm:force_make_vassal("wh_main_dwf_dwarfs", "wh_main_dwf_karak_hirn");
        cm:force_make_vassal("wh_main_dwf_dwarfs", "wh_main_dwf_karak_izor");
        cm:force_make_vassal("wh_main_dwf_dwarfs", "wh_main_dwf_karak_kadrin");
        cm:force_make_vassal("wh_main_dwf_dwarfs", "wh_main_dwf_karak_norn");
        cm:force_make_vassal("wh_main_dwf_dwarfs", "wh_main_dwf_karak_ziflin");
        cm:force_make_vassal("wh_main_dwf_dwarfs", "wh_main_dwf_kraka_drak"); -- DEBUG
        cm:force_make_vassal("wh_main_dwf_dwarfs", "wh_main_dwf_zhufbar");
        cm:force_make_vassal("wh_main_dwf_dwarfs", "wh2_main_dwf_greybeards_prospectors");

        output("#### Greenskin Tribes ####"); -- TODO
        cm:make_region_seen_in_shroud("wh_main_eastern_badlands_karak_eight_peaks", "wh_main_grn_crooked_moon");

        output("#### Vampire Counts ####");
        cm:force_declare_war("wh_main_vmp_schwartzhafen", "wh_main_vmp_rival_sylvanian_vamps", true, true);
        cm:force_declare_war("wh_main_vmp_schwartzhafen", "wh_main_vmp_vampire_counts", true, true);
        cm:force_make_vassal("wh_main_vmp_schwartzhafen", "wh_main_vmp_mousillon");
        cm:transfer_region_to_faction("wh_main_eastern_sylvania_eschen", "wh_main_vmp_vampire_counts");
        cm:transfer_region_to_faction("wh_main_eastern_sylvania_waldenhof", "wh_main_vmp_vampire_counts");
        cm:transfer_region_to_faction("wh_main_western_sylvania_castle_templehof", "wh_main_vmp_schwartzhafen");
        cm:transfer_region_to_faction("wh_main_western_sylvania_fort_oberstyre", "wh_main_vmp_schwartzhafen");

        output("#### Warriors of Chaos ####"); -- TODO

        output("#### Beastmen ####"); -- TODO

        output("#### Wood Elves ####");
        cm:force_make_vassal("wh_dlc05_wef_wood_elves", "wh_dlc05_wef_argwylon");
        cm:force_make_vassal("wh_dlc05_wef_wood_elves", "wh_dlc05_wef_torgovann");
        cm:force_make_vassal("wh_dlc05_wef_wood_elves", "wh_dlc05_wef_wydrioth");

        output("#### Bretonnian Kingdoms ####");
        cm:force_make_vassal("wh_main_brt_bretonnia", "wh_main_brt_bordeleaux");
        cm:force_make_vassal("wh_main_brt_bretonnia", "wh_main_brt_carcassonne");
        cm:force_make_vassal("wh_main_brt_bretonnia", "wh_main_brt_artois");
        cm:force_make_vassal("wh_main_brt_bretonnia", "wh_main_brt_bastonne");
        cm:force_make_vassal("wh_main_brt_bretonnia", "wh_main_brt_lyonesse");
        cm:force_make_vassal("wh_main_brt_bretonnia", "wh_main_brt_parravon");
        cm:force_make_vassal("wh_main_brt_bretonnia", "wh2_main_brt_knights_of_origo");
        cm:force_make_vassal("wh_main_brt_bretonnia", "wh2_main_brt_knights_of_the_flame");
        cm:force_make_vassal("wh_main_brt_bretonnia", "wh2_main_brt_thegans_crusaders");        

        output("#### Norscan Tribes ####"); -- TODO
        --cm:force_make_vassal("wh_dlc08_nor_norsca", "wh_dlc08_nor_helspire_tribe");
        --cm:force_make_vassal("wh_dlc08_nor_norsca", "wh_dlc08_nor_vanaheimlings");
        --cm:force_make_vassal("wh_dlc08_nor_wintertooth", "wh_dlc08_nor_goromadny_tribe");
        --cm:force_make_vassal("wh_dlc08_nor_wintertooth", "wh_dlc08_nor_naglfarlings");

        output("#### Kislev ####"); -- TODO

        output("#### Southern Realms ####"); -- TODO

        output("#### High Elves ####"); -- TODO
        --cm:force_make_vassal("wh2_main_hef_saphery", "wh2_main_hef_order_of_loremasters");
        cm:force_make_vassal("wh2_main_hef_eataine", "wh2_main_hef_avelorn"); -- DEBUG
        cm:force_make_vassal("wh2_main_hef_eataine", "wh2_main_hef_caledor"); -- DEBUG
        cm:force_make_vassal("wh2_main_hef_eataine", "wh2_main_hef_chrace"); -- DEBUG
        cm:force_make_vassal("wh2_main_hef_eataine", "wh2_main_hef_cothique"); -- DEBUG
        cm:force_make_vassal("wh2_main_hef_eataine", "wh2_main_hef_ellyrion"); -- DEBUG
        cm:force_make_vassal("wh2_main_hef_eataine", "wh2_main_hef_nagarythe"); -- DEBUG
        cm:force_make_vassal("wh2_main_hef_eataine", "wh2_main_hef_saphery"); -- DEBUG
        cm:force_make_vassal("wh2_main_hef_eataine", "wh2_main_hef_tiranoc"); -- DEBUG
        cm:force_make_vassal("wh2_main_hef_eataine", "wh2_main_hef_yvresse"); -- DEBUG
        cm:force_make_vassal("wh2_main_hef_eataine", "wh2_main_hef_order_of_loremasters"); -- DEBUG

        output("#### Dark Elves ####");
        cm:force_make_vassal("wh2_main_def_naggarond", "wh2_main_def_cult_of_pleasure");
        cm:force_make_vassal("wh2_main_def_naggarond", "wh2_main_def_bleak_holds");
        cm:force_make_vassal("wh2_main_def_naggarond", "wh2_main_def_clar_karond");
        cm:force_make_vassal("wh2_main_def_naggarond", "wh2_main_def_cult_of_excess");
        cm:force_make_vassal("wh2_main_def_naggarond", "wh2_main_def_deadwood_sentinels");
        cm:force_make_vassal("wh2_main_def_naggarond", "wh2_main_def_ghrond");
        cm:force_make_vassal("wh2_main_def_naggarond", "wh2_main_def_hag_graef");
        cm:force_make_vassal("wh2_main_def_naggarond", "wh2_main_def_har_ganeth");
        cm:force_make_vassal("wh2_main_def_naggarond", "wh2_main_def_karond_kar");
        cm:force_make_vassal("wh2_main_def_naggarond", "wh2_main_def_scourge_of_khaine");
        cm:force_make_vassal("wh2_main_def_naggarond", "wh2_main_def_ssildra_tor");
        cm:force_make_vassal("wh2_main_def_naggarond", "wh2_main_def_the_forgebound");

        output("#### Lizardmen ####"); -- TODO
        cm:force_make_vassal("wh2_main_lzd_hexoatl", "wh2_main_lzd_last_defenders");
        cm:force_make_vassal("wh2_main_lzd_hexoatl", "wh2_main_lzd_itza"); -- DEBUG
        cm:force_make_vassal("wh2_main_lzd_hexoatl", "wh2_main_lzd_sentinels_of_xeti"); -- DEBUG
        cm:force_make_vassal("wh2_main_lzd_hexoatl", "wh2_main_lzd_teotiqua"); -- DEBUG
        cm:force_make_vassal("wh2_main_lzd_hexoatl", "wh2_main_lzd_tlaxtlan"); -- DEBUG
        cm:force_make_vassal("wh2_main_lzd_hexoatl", "wh2_main_lzd_xlanhuapec"); -- DEBUG

        output("#### Skaven ####"); -- TODO
         -- Military alliance between Great Clans
         -- Defensive alliances between everyone else?
        cm:force_make_vassal("wh2_main_skv_clan_mors", "wh2_dlc09_skv_clan_rictus"); -- DEBUG
        cm:force_make_vassal("wh2_main_skv_clan_mors", "wh2_main_skv_clan_eshin"); -- DEBUG
        cm:force_make_vassal("wh2_main_skv_clan_mors", "wh2_main_skv_clan_gnaw"); -- DEBUG
        cm:force_make_vassal("wh2_main_skv_clan_mors", "wh2_main_skv_clan_mordkin"); -- DEBUG
        cm:force_make_vassal("wh2_main_skv_clan_mors", "wh2_main_skv_clan_moulder"); -- DEBUG
        cm:force_make_vassal("wh2_main_skv_clan_mors", "wh2_main_skv_clan_pestilens"); -- DEBUG
        cm:force_make_vassal("wh2_main_skv_clan_mors", "wh2_main_skv_clan_skyre"); -- DEBUG

        output("#### Tomb Kings ####");
        cm:force_make_vassal("wh2_dlc09_tmb_khemri", "wh2_dlc09_tmb_lybaras");
        cm:force_make_vassal("wh2_dlc09_tmb_khemri", "wh2_dlc09_tmb_exiles_of_nehek");
        cm:force_make_vassal("wh2_dlc09_tmb_khemri", "wh2_dlc09_tmb_numas");
        cm:force_make_vassal("wh2_dlc09_tmb_khemri", "wh2_dlc09_tmb_dune_kingdoms");
        cm:force_make_vassal("wh2_dlc09_tmb_khemri", "wh2_dlc09_tmb_rakaph_dynasty");
        cm:force_make_vassal("wh2_dlc09_tmb_khemri", "wh2_dlc09_tmb_followers_of_nagash");
    else
        -- call functions here that you want to fire every time you load the game.
    end;
end;