
# this file has to define two global variables
# $folders : [ Folder ]
# $all_tags: { :tagname => [ String ] }







# ============================================================
# glues everything together
def match_glue( *args )

    def tag_help2( elem_list , suffix)
        separators = [ '-', '_', ' ', '.', '', '#']
        result = separators.map do |separator|
            elem_list.map do |elem|
                "#{elem}#{separator}#{suffix}"
            end
        end
        result.flatten
    end

    def reco( result , rest )
        if rest.size == 0 
            return result
        end
        reco( tag_help2( result , rest[0] ), rest.drop(1) )
    end

    args.flatten!
    reco( args.take(1), args.drop(1) )
end





# ============================================================
# to filter out bpm
meta_tags_bpm = (90..200).map do |bpm|
    { "#{bpm}bpm" => match_glue( bpm, "bpm" ) }
    #{ "#{bpm}bpm" => [ bpm.to_s ] }
end
meta_tags_bpm    = meta_tags_bpm.reduce( {}, :merge )
meta_folders_bpm = meta_tags_bpm.keys.map do |tag|
    Folder.new([ :loop, tag ])
end
$bpm_tags = meta_tags_bpm.keys





# tags which will not result in a folder
meta_tags = {
    # stuff (sort me )
    :pulse        => %w( pulse                       ) ,
    :keyboard     => %w( keyboard keys               ) ,
    :loop         => %w( loop bpm ),
    #:loop         => [ 'loop' ] + (90..200).map { |bpm| bpm.to_s }, 
    :guitar       => %w( guitar                      ) ,
    :groove       => %w( groove groovy               ) ,
    :minimal      => %w( minimal 8bit) ,
    :scratch      => %w( scratch turntabl            ) ,
    :reverse      => %w( reverse                     ) ,
    :brass        => %w( brass tuba                  ) ,
    :rhodes       => %w( wurly wurlitz rhodes        ) ,
    :oneshots     => %w( oneshot shot                ) ,
    :robotvocoder => %w( vocoder robot               ) ,
    :piano        => %w( piano keyboard              ) ,
    :organ        => %w( organ                       ) ,
    :deep         => %w( deep                        ) ,
    :strings      => %w( string pizzi                ) ,
    :synth        => %w( synth                       ) ,
    :pads         => %w( pad atmo                    ) ,
    :lead         => %w( lead                        ) ,
    :bass         => %w( bass                        ) ,
    :vocal        => %w( vocal vox female male human ) ,
    :fx           => %w( fx                          ) ,
    :sweep        => %w( woosh sweep                 ) ,
    :glitch => %w( glitch ),
    :vinyl        => %w( vinyl                       ) ,
    :instrument   => %w( instrument                  ) ,
    # drumkit
    :drumkit      => %w( drumkit drum kit            ) ,
    :kick    => %w( kick bassdrum                 ) ,
    :hihat   => %w( hihat hat hit openhi closedhi ) ,
    :clap    => %w( clap                          ) ,
    :snare   => %w( snare                         ) ,
    :ride    => %w( ride                          ) ,
    :rim     => %w( rim                           ) ,
    :crash   => %w( crash cymbal cym              ) ,
    :tom     => %w( tom                           ) ,
    :clave   => %w( clave                         ) ,
    :bongo   => %w( bongo conga                   ) ,
    :shaker  => %w( shaker                        ) ,
    :mallet  => %w( mallet                        ) ,
    :wood    => %w( wood                          ) ,
    :whistle => %w( whistle                       ) ,
    :stick   => %w( stick                         ) ,
    :bell => %w( cow bell                      ) ,
    :maraca  => %w( maraca ),
    :percussion   => %w( percussion perc             ) ,
    # packages
    :chipshop    => %w( chipshop    ) ,
    :loopmasters => %w( loopmasters ) ,
    :ueberschall => %w( ueberschall ) ,
    :drum_zone   => %w( drum_zone   ) ,
    # genre
    :dnb       => %w( dnb drum_n_bass drum_and_bass ) ,
    :dub       => %w( dub                           ) ,
    :noise     => %w( noise noize white             ) ,
    :jazz      => %w( jazz swing                    ) ,
    :breakbeat => %w( breakbeat                     ) ,
    :hiphop    => %w( hiphop rap                    ) ,
    :funkdisco    => %w( disco funk                  ) ,
    :ambient => %w( ambient ) ,







    # brands
    :akai_mpc2000      => match_glue( %w( mpc 2000                )  ) ,
    :akai_xe8          => match_glue( %w( akai xe 8               )  ) ,
    :alesis_hr16       => match_glue( %w( alesis hr16a            )  ) ,
    :arp_axxe          => match_glue( %w( arp axxe                )  ) ,
    :austin_arb6       => match_glue( %w( austin arb 6            )  ) ,
    :boss_dr_110       => match_glue( %w( boss dr 110             )  ) ,
    :boss_dr_220       => match_glue( %w( boss dr 220             )  ) ,
    :boss_dr_55        => match_glue( %w( boss dr 55              )  ) ,
    :boss_dr_pad_drp   => match_glue( %w( boss dr pad drp         )  ) ,
    :boss_hc_2         => match_glue( %w( boss hc 2               )  ) ,
    :boss_pc_2         => match_glue( %w( boss pc 2               )  ) ,
    :boss_ps_2         => match_glue( %w( boss ps 2               )  ) ,
    :boss_sp_505       => match_glue( %w( boss sp 505             )  ) ,
    :casio_cz_230S     => match_glue( %w( casio cz 230s           )  ) ,
    :casio_ma_101      => match_glue( %w( casio ma 101            )  ) ,
    :casio_mt_100      => match_glue( %w( casio mt 100            )  ) ,
    :casio_mt_18       => match_glue( %w( casio mt 18             )  ) ,
    :casio_mt_500      => match_glue( %w( casio mt 500            )  ) ,
    :casio_mt_800      => match_glue( %w( casio mt 800            )  ) ,
    :casio_pt_82       => match_glue( %w( casio pt 82             )  ) ,
    :casio_rapman      => match_glue( %w( casio rapman            )  ) ,
    :casio_rz1         => match_glue( %w( casio rz1               )  ) ,
    :casio_sa10        => match_glue( %w( casio sa 10             )  ) ,
    :casio_sk1         => match_glue( %w( casio sk1               )  ) ,
    :casio_sk5         => match_glue( %w( casio sk5               )  ) ,
    :chaser_pr80       => match_glue( %w( chaser pr 80            )  ) ,
    :cheetah_md16      => match_glue( %w( cheetah md16            )  ) ,
    :cheetah_specdrum  => match_glue( %w( cheetah specdrum        )  ) ,
    :coron_drum        => match_glue( %w( coron drum synce ds 7   )  ) ,
    :daytone_drum      => match_glue( %w( daytone drum synthe rds )  ) ,
    :denon_crb90       => match_glue( %w( denon crb 90            )  ) ,
    :drboehm_s78       => match_glue( %w( drboehm s 78            )  ) ,
    :drumfire_df500    => match_glue( %w( drumfire df 500         )  ) ,
    :eko_musicbox12    => match_glue( %w( eko musicbox 12         )  ) ,
    :eko_ritmo20       => match_glue( %w( eko ritmo 20            )  ) ,
    :ensoniq_asrX      => match_glue( %w( ensoniq asr x           )  ) ,
    :ensoniq_eps       => match_glue( %w( ensoniq eps             )  ) ,
    :estradin_pulsar   => match_glue( %w( estradin pulsar         )  ) ,
    :forat_f9000       => match_glue( %w( forat f 9000            )  ) ,
    :fricke_mfb301     => match_glue( %w( fricke mfb 301          )  ) ,
    :fricke_mfb501     => match_glue( %w( fricke mfb 501          )  ) ,
    :fricke_mfb512     => match_glue( %w( fricke mfb 512          )  ) ,
    :fricke_mfb712     => match_glue( %w( fricke mfb 712          )  ) ,
    :gem_drum15        => match_glue( %w( gem drum15              )  ) ,
    :hammond_auto64    => match_glue( %w( hammond auto vari64     )  ) ,
    :hammond_rhythm2   => match_glue( %w( hammond rhythm2         )  ) ,
    :kawai_acr20       => match_glue( %w( kawai acr 20            )  ) ,
    :kawai_k1          => match_glue( %w( kawai k 1               )  ) ,
    :kawai_r100        => match_glue( %w( kawai r 100             )  ) ,
    :kawai_r50         => match_glue( %w( kawai r 50              )  ) ,
    :kawai_sx240       => match_glue( %w( kawai sx 240            )  ) ,
    :kawai_xd5         => match_glue( %w( kawai xd 5              )  ) ,
    :kay_r8            => match_glue( %w( kay r 8                 )  ) ,
    :keio_checkmate    => match_glue( %w( keio checkmate          )  ) ,
    :ketron_sd5        => match_glue( %w( ketron sd 5             )  ) ,
    :korg_ddd1         => match_glue( %w( korg ddd 1              )  ) ,
    :korg_ddm110       => match_glue( %w( korg ddm 110            )  ) ,
    :korg_ddm220       => match_glue( %w( korg ddm 220            )  ) ,
    :korg_drm1         => match_glue( %w( korg drm 1              )  ) ,
    :korg_kpr77        => match_glue( %w( korg kpr 77             )  ) ,
    :korg_kr33         => match_glue( %w( korg kr 33              )  ) ,
    :korg_kr55         => match_glue( %w( korg kr 55              )  ) ,
    :korg_minipops     => match_glue( %w( korg minipops           )  ) ,
    :korg_mp7          => match_glue( %w( korg mp 7               )  ) ,
    :korg_prophecy     => match_glue( %w( korg prophecy           )  ) ,
    :korg_prowave      => match_glue( %w( korg prowave            )  ) ,
    :korg_pss50        => match_glue( %w( korg pss 50             )  ) ,
    :korg_radias       => match_glue( %w( korg radias             )  ) ,
    :korg_sr120        => match_glue( %w( korg sr 120             )  ) ,
    :korg_t1           => match_glue( %w( korg t1                 )  ) ,
    :korg_t3           => match_glue( %w( korg t3                 )  ) ,
    :kurzweil_k2000    => match_glue( %w( kurzweil k2000          )  ) ,
    :linn_adrenalinn1  => match_glue( %w( linn adrenalinn1        )  ) ,
    :linn_lm1          => match_glue( %w( linn lm 1               )  ) ,
    :maestro_g2        => match_glue( %w( maestro g2              )  ) ,
    :moog_modular55    => match_glue( %w( moog modular 55         )  ) ,
    :moog_voyager      => match_glue( %w( moog voyager            )  ) ,
    :mti_ao1           => match_glue( %w( mti ao 1                )  ) ,
    :mxr_185           => match_glue( %w( mxr 185                 )  ) ,
    :nintendo          => match_glue( %w( nintendo                )  ) ,
    :panasonic_rd9844  => match_glue( %w( panasonic rd 9844       )  ) ,
    :pearl_drx1        => match_glue( %w( pearl drx 1             )  ) ,
    :rhodes_polaris    => match_glue( %w( rhodes polaris          )  ) ,
    :roland_cr1000     => match_glue( %w( roland cr 1000          )  ) ,
    :roland_cr68       => match_glue( %w( roland cr 68            )  ) ,
    :roland_cr78       => match_glue( %w( roland cr 78            )  ) ,
    :roland_cr80       => match_glue( %w( roland cr 80            )  ) ,
    :roland_d110       => match_glue( %w( roland d 110            )  ) ,
    :roland_d70        => match_glue( %w( roland d 70             )  ) ,
    :roland_ddr30      => match_glue( %w( roland ddr 30           )  ) ,
    :roland_e10        => match_glue( %w( roland e 10             )  ) ,
    :roland_mc202      => match_glue( %w( mc 202                  )  ) ,
    :roland_mc909      => match_glue( %w( mc 909                  )  ) ,
    :roland_mt32       => match_glue( %w( roland mt 32            )  ) ,
    :roland_pb300      => match_glue( %w( roland pb 300           )  ) ,
    :roland_sh3a       => match_glue( %w( roland sh 3a            )  ) ,
    :roland_sp606      => match_glue( %w( sp 606                  )  ) ,
    :roland_spd8       => match_glue( %w( roland spd 8            )  ) ,
    :roland_tr33       => match_glue( %w( roland tr 33            )  ) ,
    :roland_tr41       => match_glue( %w( roland tr 41            )  ) ,
    :roland_tr505      => match_glue( %w( tr 505                  )  ) ,
    :roland_tr55       => match_glue( %w( roland tr 55            )  ) ,
    :roland_tr626      => match_glue( %w( roland tr 626           )  ) ,
    :roland_tr66       => match_glue( %w( roland tr 66            )  ) ,
    :roland_tr707      => match_glue( %w( tr 707                  )  ) ,
    :roland_tr727      => match_glue( %w( tr 727                  )  ) ,
    :roland_tr77       => match_glue( %w( roland tr 77            )  ) ,
    :roland_tr808      => match_glue( %w( tr 808                  )  ) ,
    :roland_tr909      => match_glue( %w( tr 909                  )  ) ,
    :simmons_sds1000   => match_glue( %w( sds 1000                )  ) ,
    :simmons_sds200    => match_glue( %w( sds 200                 )  ) ,
    :simmons_sds7      => match_glue( %w( sds 7                   )  ) ,
    :technics_ax5      => match_glue( %w( ax 5                    )  ) ,
    :technics_pcm_dp50 => match_glue( %w( pcm dp 50               )  ) ,
    :wersi_prisma      => match_glue( %w( wersi prisma dx 5       )  ) ,
    :wiard_300         => match_glue( %w( wiard 300               )  ) ,
    :yamaha_an200      => match_glue( %w( yamaha an 200           )  ) ,
    :yamaha_cs15       => match_glue( %w( yamaha cs 15            )  ) ,
    :yamaha_cs40M      => match_glue( %w( yamaha cs 40m           )  ) ,
    :yamaha_dd10       => match_glue( %w( yamaha dd 10            )  ) ,
    :yamaha_dd11       => match_glue( %w( yamaha dd 11            )  ) ,
    :yamaha_dd5        => match_glue( %w( yamaha dd 5             )  ) ,
    :yamaha_ptx8       => match_glue( %w( ptx 8                   )  ) ,
    :yamaha_rx11       => match_glue( %w( rx 11                   )  ) ,
    :yamaha_rx120      => match_glue( %w( rx 120                  )  ) ,
    :yamaha_rx17       => match_glue( %w( rx 17                   )  ) ,
    :yamaha_rx21       => match_glue( %w( rx 21                   )  ) ,
    :yamaha_rx5        => match_glue( %w( rx 15                   )  ) ,
    :yamaha_shs200     => match_glue( %w( yamaha shs 200          )  ) ,
    :yamaha_tx16       => match_glue( %w( yamaya tx 16            )  ) ,
    :roland_jupiter8   => match_glue( %w( jp 8                    ) ) + match_glue( 'jupiter' , '8' ) ,

}

# tags to extract from sample Map( TagName , List( StringMatches ) )
$all_tags = meta_tags.merge( meta_tags_bpm )











# folders which will be created List( List( FolderName ))
$folders = [
    Folder.new( [ :deep, :bass ], [:loop]),
    Folder.new( [ :deep, :kick ], [:loop]),
    Folder.new( [ :deep, :hihat], [:loop]),
    Folder.new( [ :deep, :snare], [:loop]),
    #
    Folder.new( [ :ambient ] , [ :loop ] ) ,
    Folder.new( [ :pads  ] , [ :loop ] ) ,
    Folder.new( [ :lead  ] , [ :loop ] ) ,
    Folder.new( [ :vocal ] , [ :loop ] ) ,
    #
    #
    Folder.new( [ :instrument ], [ :loop ] ),
    #
    Folder.new( [ :sweep            ] , [ ] , [ :fx , :sweep  ] ) ,
    Folder.new( [ :glitch           ] , [ ] , [ :fx , :glitch ] ) ,
    #
    Folder.new( [ :strings        ] , [ :loop ] ) ,
    #
    Folder.new( [ :synth          ] , [ :loop, :drumkit, :kick, :hihat, :clap, :snare,
                                        :ride, :crash, :rim, :tom, :bongo, :percussion, :shaker, :bell,
                                        :clave,:whistle, :maraca ] ) ,
    Folder.new( [ :loop, :synth   ]             ) ,
    Folder.new( [ :noise  ] , [ :loop ], [ :synth, :noise ] ) ,
    Folder.new( [ :synth, :glitch ] , [ :loop ] ) ,
    # drum
    Folder.new( [ :drumkit , :bass ] , [ :loop ]),
    Folder.new( [ :drumkit , :fx   ] , [ :loop ]),
    # brands
    Folder.new( [ :roland_mc202], [ :loop ], [ :synth  , :roland_mc202] ),
]




# ============================================================
# Bass

bass = [
    Folder.new( [ :bass            ] , [ :loop , :kick ] ) ,
    Folder.new( [ :bass, :deep     ] , [ :loop , :kick ] ),
    Folder.new( [ :bass, :kick     ] , [ :loop         ] ) ,
]

$folders += bass




# ============================================================
# add_loop
def add_loop( tag )
    folder = [ Folder.new( [ :loop, tag ] ) ]
    folder_bpm = $bpm_tags.map do |bpm_tag| 
        [
            Folder.new( [ :loop , tag     , bpm_tag ].flatten ),
            Folder.new( [ :loop , bpm_tag , tag     ].flatten )
        ]
    end
    folder + folder_bpm.flatten
end

$folders += add_loop( [] )
$folders += add_loop( :dnb        )
$folders += add_loop( :dub        )
$folders += add_loop( :jazz       )
$folders += add_loop( :noise      )
$folders += add_loop( :breakbeat  )
$folders += add_loop( :hiphop     )
$folders += add_loop( :funkdisco  )
$folders += add_loop( :ambient    )
$folders += add_loop( :vinyl      )
$folders += add_loop( :fx         )
$folders += add_loop( :pads       )
$folders += add_loop( :lead       )
$folders += add_loop( :bass       )
$folders += add_loop( :vocal      )
$folders += add_loop( :drumkit    )
$folders += add_loop( :kick       )
$folders += add_loop( :percussion )
$folders += add_loop( :glitch     )
$folders += add_loop( :deep       )
$folders += add_loop( :strings    )


# ============================================================
def add_instrument( tag )
    [
        Folder.new( [ :moog ], [ :loop ], [ :instrument, :moog ])
    ]
end

$folders += add_instrument( :roland_jupiter8 )
$folders += add_instrument( :moog )







# ============================================================
# drums
$drum_tags = [ 
    :kick ,:hihat ,:clap ,:snare ,:ride ,
    :rim ,:crash ,:tom ,:clave, :bongo, :whistle, 
    :shaker, :mallet ,:wood ,:stick , :bell,
    :maraca, :fx ,:percussion 
]

def drum_kit( brand_tag , drum_tags )

    all_combinations = drum_tags.map do |tag|
        [
            Folder.new( [ brand_tag, tag ].flatten , [ :loop ] , [ :drumkit , brand_tag, tag ].flatten ),
            Folder.new( [ brand_tag, tag ].flatten , [ :loop ] , [ :drumkit , tag, brand_tag ].flatten ),
        ]
    end

    if brand_tag.empty?
        top_level = Folder.new( [ brand_tag ] , [ :loop ] , [ :drumkit , brand_tag ] ) 
        [top_level] + all_combinations
    else
        all_combinations
    end
end

$folders += drum_kit( []            , $drum_tags )
$folders += drum_kit( :akai_mpc2000      , $drum_tags )
$folders += drum_kit( :akai_xe8          , $drum_tags )
$folders += drum_kit( :alesis_hr16       , $drum_tags )
$folders += drum_kit( :arp_axxe          , $drum_tags )
$folders += drum_kit( :austin_arb6       , $drum_tags )
$folders += drum_kit( :boss_dr_110       , $drum_tags )
$folders += drum_kit( :boss_dr_220       , $drum_tags )
$folders += drum_kit( :boss_dr_55        , $drum_tags )
$folders += drum_kit( :boss_dr_pad_drp   , $drum_tags )
$folders += drum_kit( :boss_hc_2         , $drum_tags )
$folders += drum_kit( :boss_pc_2         , $drum_tags )
$folders += drum_kit( :boss_ps_2         , $drum_tags )
$folders += drum_kit( :boss_sp_505       , $drum_tags )
$folders += drum_kit( :casio_cz_230S     , $drum_tags )
$folders += drum_kit( :casio_ma_101      , $drum_tags )
$folders += drum_kit( :casio_mt_100      , $drum_tags )
$folders += drum_kit( :casio_mt_18       , $drum_tags )
$folders += drum_kit( :casio_mt_500      , $drum_tags )
$folders += drum_kit( :casio_mt_800      , $drum_tags )
$folders += drum_kit( :casio_pt_82       , $drum_tags )
$folders += drum_kit( :casio_rapman      , $drum_tags )
$folders += drum_kit( :casio_rz1         , $drum_tags )
$folders += drum_kit( :casio_sa10        , $drum_tags )
$folders += drum_kit( :casio_sk1         , $drum_tags )
$folders += drum_kit( :casio_sk5         , $drum_tags )
$folders += drum_kit( :chaser_pr80       , $drum_tags )
$folders += drum_kit( :cheetah_md16      , $drum_tags )
$folders += drum_kit( :cheetah_specdrum  , $drum_tags )
$folders += drum_kit( :coron_drum        , $drum_tags )
$folders += drum_kit( :daytone_drum      , $drum_tags )
$folders += drum_kit( :denon_crb90       , $drum_tags )
$folders += drum_kit( :drboehm_s78       , $drum_tags )
$folders += drum_kit( :drumfire_df500    , $drum_tags )
$folders += drum_kit( :eko_musicbox12    , $drum_tags )
$folders += drum_kit( :eko_ritmo20       , $drum_tags )
$folders += drum_kit( :ensoniq_asrX      , $drum_tags )
$folders += drum_kit( :ensoniq_eps       , $drum_tags )
$folders += drum_kit( :estradin_pulsar   , $drum_tags )
$folders += drum_kit( :forat_f9000       , $drum_tags )
$folders += drum_kit( :fricke_mfb301     , $drum_tags )
$folders += drum_kit( :fricke_mfb501     , $drum_tags )
$folders += drum_kit( :fricke_mfb512     , $drum_tags )
$folders += drum_kit( :fricke_mfb712     , $drum_tags )
$folders += drum_kit( :gem_drum15        , $drum_tags )
$folders += drum_kit( :hammond_auto64    , $drum_tags )
$folders += drum_kit( :hammond_rhythm2   , $drum_tags )
$folders += drum_kit( :kawai_acr20       , $drum_tags )
$folders += drum_kit( :kawai_k1          , $drum_tags )
$folders += drum_kit( :kawai_r100        , $drum_tags )
$folders += drum_kit( :kawai_r50         , $drum_tags )
$folders += drum_kit( :kawai_sx240       , $drum_tags )
$folders += drum_kit( :kawai_xd5         , $drum_tags )
$folders += drum_kit( :kay_r8            , $drum_tags )
$folders += drum_kit( :keio_checkmate    , $drum_tags )
$folders += drum_kit( :ketron_sd5        , $drum_tags )
$folders += drum_kit( :korg_ddd1         , $drum_tags )
$folders += drum_kit( :korg_ddm110       , $drum_tags )
$folders += drum_kit( :korg_ddm220       , $drum_tags )
$folders += drum_kit( :korg_drm1         , $drum_tags )
$folders += drum_kit( :korg_kpr77        , $drum_tags )
$folders += drum_kit( :korg_kr33         , $drum_tags )
$folders += drum_kit( :korg_kr55         , $drum_tags )
$folders += drum_kit( :korg_minipops     , $drum_tags )
$folders += drum_kit( :korg_mp7          , $drum_tags )
$folders += drum_kit( :korg_prophecy     , $drum_tags )
$folders += drum_kit( :korg_prowave      , $drum_tags )
$folders += drum_kit( :korg_pss50        , $drum_tags )
$folders += drum_kit( :korg_radias       , $drum_tags )
$folders += drum_kit( :korg_sr120        , $drum_tags )
$folders += drum_kit( :korg_t1           , $drum_tags )
$folders += drum_kit( :korg_t3           , $drum_tags )
$folders += drum_kit( :kurzweil_k2000    , $drum_tags )
$folders += drum_kit( :linn_adrenalinn1  , $drum_tags )
$folders += drum_kit( :linn_lm1          , $drum_tags )
$folders += drum_kit( :maestro_g2        , $drum_tags )
$folders += drum_kit( :moog_modular55    , $drum_tags )
$folders += drum_kit( :moog_voyager      , $drum_tags )
$folders += drum_kit( :mti_ao1           , $drum_tags )
$folders += drum_kit( :mxr_185           , $drum_tags )
$folders += drum_kit( :nintendo          , $drum_tags )
$folders += drum_kit( :panasonic_rd9844  , $drum_tags )
$folders += drum_kit( :pearl_drx1        , $drum_tags )
$folders += drum_kit( :rhodes_polaris    , $drum_tags )
$folders += drum_kit( :roland_cr1000     , $drum_tags )
$folders += drum_kit( :roland_cr68       , $drum_tags )
$folders += drum_kit( :roland_cr78       , $drum_tags )
$folders += drum_kit( :roland_cr80       , $drum_tags )
$folders += drum_kit( :roland_d110       , $drum_tags )
$folders += drum_kit( :roland_d70        , $drum_tags )
$folders += drum_kit( :roland_ddr30      , $drum_tags )
$folders += drum_kit( :roland_e10        , $drum_tags )
$folders += drum_kit( :roland_mc202      , $drum_tags )
$folders += drum_kit( :roland_mc909      , $drum_tags )
$folders += drum_kit( :roland_mt32       , $drum_tags )
$folders += drum_kit( :roland_pb300      , $drum_tags )
$folders += drum_kit( :roland_sh3a       , $drum_tags )
$folders += drum_kit( :roland_sp606      , $drum_tags )
$folders += drum_kit( :roland_spd8       , $drum_tags )
$folders += drum_kit( :roland_tr33       , $drum_tags )
$folders += drum_kit( :roland_tr41       , $drum_tags )
$folders += drum_kit( :roland_tr505      , $drum_tags )
$folders += drum_kit( :roland_tr55       , $drum_tags )
$folders += drum_kit( :roland_tr626      , $drum_tags )
$folders += drum_kit( :roland_tr66       , $drum_tags )
$folders += drum_kit( :roland_tr707      , $drum_tags )
$folders += drum_kit( :roland_tr727      , $drum_tags )
$folders += drum_kit( :roland_tr77       , $drum_tags )
$folders += drum_kit( :roland_tr808      , $drum_tags )
$folders += drum_kit( :roland_tr909      , $drum_tags )
$folders += drum_kit( :simmons_sds1000   , $drum_tags )
$folders += drum_kit( :simmons_sds200    , $drum_tags )
$folders += drum_kit( :simmons_sds7      , $drum_tags )
$folders += drum_kit( :technics_ax5      , $drum_tags )
$folders += drum_kit( :technics_pcm_dp50 , $drum_tags )
$folders += drum_kit( :wersi_prisma      , $drum_tags )
$folders += drum_kit( :wiard_300         , $drum_tags )
$folders += drum_kit( :yamaha_an200      , $drum_tags )
$folders += drum_kit( :yamaha_cs15       , $drum_tags )
$folders += drum_kit( :yamaha_cs40M      , $drum_tags )
$folders += drum_kit( :yamaha_dd10       , $drum_tags )
$folders += drum_kit( :yamaha_dd11       , $drum_tags )
$folders += drum_kit( :yamaha_dd5        , $drum_tags )
$folders += drum_kit( :yamaha_ptx8       , $drum_tags )
$folders += drum_kit( :yamaha_rx11       , $drum_tags )
$folders += drum_kit( :yamaha_rx120      , $drum_tags )
$folders += drum_kit( :yamaha_rx17       , $drum_tags )
$folders += drum_kit( :yamaha_rx21       , $drum_tags )
$folders += drum_kit( :yamaha_rx5        , $drum_tags )
$folders += drum_kit( :yamaha_shs200     , $drum_tags )
$folders += drum_kit( :yamaha_tx16       , $drum_tags )




# ============================================================
# packages
def package( package_tag )
   [ 
    Folder.new( [ :organ  , package_tag ] .flatten                       ) ,
    Folder.new( [ :lead   , package_tag ] .flatten   , [ :loop         ] ) ,
    Folder.new( [ :guitar , package_tag ] .flatten   , [ :loop         ] ) ,
    Folder.new( [ :fx     , package_tag ] .flatten                       ) ,
    Folder.new( [ :synth  , package_tag ] .flatten   , [ :loop         ] ) ,
    Folder.new( [ :bass   , package_tag ] .flatten   , [ :loop , :kick ] ) ,
   ] + drum_kit( package_tag , $drum_tags ) + add_loop( package_tag )
end


$folders += package ( []           )
$folders += package ( :chipshop    )
$folders += package ( :loopmasters )
$folders += package ( :ueberschall )
$folders += package ( :drum_zone   )

$folders += meta_folders_bpm

puts "naive created folder instructions : #{$folders.size}"
$folders.flatten!
puts "folders created #{$folders.size}"
$folders.uniq!{ |l| l.uniq_id }
puts "maximal number of folders possilbe #{$folders.size}"

