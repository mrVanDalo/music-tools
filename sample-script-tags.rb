
# this file has to define two global variables
# $folders : [ Folder ]
# $all_tags: { :tagname => [ String ] }


def tag_help( prefix, suffix)
    [ '-', '_', ' ', '.', '', '#'].map do |separator|
        "#{prefix}#{separator}#{suffix}"
    end
end

# need to filter out files which are loops from drum/kick (for example)

# to filter out bpm
meta_tags_bpm = (90..200).map do |bpm|
    #{ "#{bpm}bpm" => tag_help( bpm, "bpm" ) }
    { "#{bpm}bpm" => [ bpm.to_s ] }
end
meta_tags_bpm    = meta_tags_bpm.reduce( {}, :merge )
meta_folders_bpm = meta_tags_bpm.keys.map do |tag|
    Folder.new([ :loop, tag ])
end
$bpm_tags = meta_tags_bpm.keys

# tags which will result in a folder (:all)
folder_tags = {
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
}

# tags which will not result in a folder
meta_tags = {
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
    :cow     => %w( cow bell                      ) ,
    :maraca  => %w( maraca ),
    :percussion   => %w( percussion perc             ) ,
    # stuff
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
    # pack names
    :chipshop => %w( chipshop ),
    # brands
    :roland_tr808 => tag_help( 'tr', '808'),
    :roland_mc909 => tag_help( 'mc', '909'),
    :roland_mc202 => tag_help( 'mc', '202'),
    :roland_jupiter8 => tag_help( 'jp', '8') + tag_help( 'jupiter' , '8' ),
    :moog => %w( moog ),
    :yamaha_rx120 => tag_help( 'rx', '120'),
    # genre
    :dnb       => %w( dnb drum_n_bass drum_and_bass ) ,
    :dub       => %w( dub                           ) ,
    :noise     => %w( noise noize white             ) ,
    :jazz      => %w( jazz swing                    ) ,
    :breakbeat => %w( breakbeat                     ) ,
    :hiphop    => %w( hiphop rap                    ) ,
    :funkdisco    => %w( disco funk                  ) ,
    :ambient => %w( ambient ) ,
}

# tags to extract from sample Map( TagName , List( StringMatches ) )
$all_tags = folder_tags.merge( meta_tags ).merge( meta_tags_bpm )


def help_loop( tag )
    folder = [ Folder.new( [ :loop, tag ] ) ]
    folder_bpm = $bpm_tags.map do |bpm_tag| 
        [
            Folder.new( [ :loop , tag     , bpm_tag ] ),
            Folder.new( [ :loop , bpm_tag , tag     ] )
        ]
    end
    folder + folder_bpm.flatten
end

def help_instrument( tag )
    [
        Folder.new( [ :moog ], [ :loop ], [ :instrument, :moog ])
    ]
end


# folders which will be created List( List( FolderName ))
$folders = [
    Folder.new( [ :deep, :bass ], [:loop]),
    Folder.new( [ :deep, :kick ], [:loop]),
    Folder.new( [ :deep, :hihat], [:loop]),
    Folder.new( [ :deep, :snare], [:loop]),
    Folder.new( [ :organ, :chipshop ]),
    #
    Folder.new( [ :ambient ] , [ :loop ] ) ,
    Folder.new( [ :pads  ] , [ :loop ] ) ,
    Folder.new( [ :lead  ] , [ :loop ] ) ,
    Folder.new( [ :vocal ] , [ :loop ] ) ,
    # bass
    Folder.new( [ :bass            ] , [ :loop , :kick ] ) ,
    Folder.new( [ :bass, :deep     ] , [:loop, :kick   ] ),
    Folder.new( [ :bass, :kick     ] , [ :loop         ] ) ,
    Folder.new( [ :bass, :chipshop ] , [ :loop , :kick ] ) ,
    #
    Folder.new( [ :lead, :chipshop ], [:loop]),
    Folder.new( [ :guitar, :chipshop ] , [ :loop ] ) ,
    #
    Folder.new( [ :instrument ], [ :loop ] ),
    #
    Folder.new( [ :fx   , :chipshop ] ) ,
    Folder.new( [ :sweep            ] , [ ] , [ :fx , :sweep  ] ) ,
    Folder.new( [ :glitch           ] , [ ] , [ :fx , :glitch ] ) ,
    #
    Folder.new( [ :strings        ] , [ :loop ] ) ,
    Folder.new( [ :loop, :strings ]             ) ,
    #
    Folder.new( [ :synth          ] , [ :loop, :drumkit, :kick, :hihat, :clap, :snare,
                                        :ride, :crash, :rim, :tom, :bongo, :percussion, :shaker, :cow,
                                        :clave,:whistle, :maraca ] ) ,
    Folder.new( [ :loop, :synth   ]             ) ,
    Folder.new( [ :noise  ] , [ :loop ], [ :synth, :noise ] ) ,
    Folder.new( [ :synth, :glitch ] , [ :loop ] ) ,
    Folder.new( [ :synth, :chipshop ] , [ :loop ] ) ,
    # drum kits
    Folder.new( [ :drumkit         ] , [ :loop ]),
    Folder.new( [ :drumkit , :bass ] , [ :loop ]),
    Folder.new( [ :drumkit , :fx   ] , [ :loop ]),
    Folder.new( [ :percussion      ] , [ :loop ] , [ :drumkit, :percussion ]),
    Folder.new( [ :kick            ] , [ :loop ] , [ :drumkit , :kick    ] ),
    Folder.new( [ :hihat           ] , [ :loop ] , [ :drumkit , :hihat   ] ),
    Folder.new( [ :clap            ] , [ :loop ] , [ :drumkit , :clap    ] ),
    Folder.new( [ :snare           ] , [ :loop ] , [ :drumkit , :snare   ] ),
    Folder.new( [ :ride            ] , [ :loop ] , [ :drumkit , :ride    ] ),
    Folder.new( [ :rim             ] , [ :loop ] , [ :drumkit , :rim     ] ),
    Folder.new( [ :crash           ] , [ :loop ] , [ :drumkit , :crash   ] ),
    Folder.new( [ :tom             ] , [ :loop ] , [ :drumkit , :tom     ] ),
    Folder.new( [ :clave           ] , [ :loop ] , [ :drumkit , :clave   ] ),
    Folder.new( [ :bongo           ] , [ :loop ] , [ :drumkit , :bongo   ] ),
    Folder.new( [ :shaker          ] , [ :loop ] , [ :drumkit , :shaker  ] ),
    Folder.new( [ :mallet          ] , [ :loop ] , [ :drumkit , :mallet  ] ),
    Folder.new( [ :wood            ] , [ :loop ] , [ :drumkit , :wood    ] ),
    Folder.new( [ :whistle         ] , [ :loop ] , [ :drumkit , :whistle ] ),
    Folder.new( [ :stick           ] , [ :loop ] , [ :drumkit , :stick   ] ),
    Folder.new( [ :cow             ] , [ :loop ] , [ :drumkit , :cow     ] ),
    Folder.new( [ :maraca          ] , [ :loop ] , [ :drumkit , :maraca  ] ),
    # brands
    Folder.new( [ :roland_mc202], [ :loop ], [ :synth  , :roland_mc202] ),
] 

def brand_drum_kit( brand_tag )
    [
        Folder.new( [ brand_tag              ] , [ :loop ] , [ :drumkit , brand_tag              ] ),
        Folder.new( [ brand_tag, :kick       ] , [ :loop ] , [ :drumkit , brand_tag, :kick       ] ),
        Folder.new( [ brand_tag, :hihat      ] , [ :loop ] , [ :drumkit , brand_tag, :hihat      ] ),
        Folder.new( [ brand_tag, :clap       ] , [ :loop ] , [ :drumkit , brand_tag, :clap       ] ),
        Folder.new( [ brand_tag, :snare      ] , [ :loop ] , [ :drumkit , brand_tag, :snare      ] ),
        Folder.new( [ brand_tag, :ride       ] , [ :loop ] , [ :drumkit , brand_tag, :ride       ] ),
        Folder.new( [ brand_tag, :rim        ] , [ :loop ] , [ :drumkit , brand_tag, :rim        ] ),
        Folder.new( [ brand_tag, :crash      ] , [ :loop ] , [ :drumkit , brand_tag, :crash      ] ),
        Folder.new( [ brand_tag, :tom        ] , [ :loop ] , [ :drumkit , brand_tag, :tom        ] ),
        Folder.new( [ brand_tag, :clave      ] , [ :loop ] , [ :drumkit , brand_tag, :clave      ] ),
        Folder.new( [ brand_tag, :bongo      ] , [ :loop ] , [ :drumkit , brand_tag, :bongo      ] ),
        Folder.new( [ brand_tag, :shaker     ] , [ :loop ] , [ :drumkit , brand_tag, :shaker     ] ),
        Folder.new( [ brand_tag, :mallet     ] , [ :loop ] , [ :drumkit , brand_tag, :mallet     ] ),
        Folder.new( [ brand_tag, :wood       ] , [ :loop ] , [ :drumkit , brand_tag, :wood       ] ),
        Folder.new( [ brand_tag, :stick      ] , [ :loop ] , [ :drumkit , brand_tag, :stick      ] ),
        Folder.new( [ brand_tag, :cow        ] , [ :loop ] , [ :drumkit , brand_tag, :cow        ] ),
        Folder.new( [ brand_tag, :maraca     ] , [ :loop ] , [ :drumkit , brand_tag, :maraca     ] ),
        Folder.new( [ brand_tag, :fx         ] , [ :loop ] , [ :drumkit , brand_tag, :fx         ] ),
        Folder.new( [ brand_tag, :percussion ] , [ :loop ] , [ :drumkit , brand_tag, :percussion ] ),

        Folder.new( [ brand_tag, :kick       ] , [ :loop ] , [ :drumkit , :kick       , brand_tag ] ),
        Folder.new( [ brand_tag, :hihat      ] , [ :loop ] , [ :drumkit , :hihat      , brand_tag ] ),
        Folder.new( [ brand_tag, :clap       ] , [ :loop ] , [ :drumkit , :clap       , brand_tag ] ),
        Folder.new( [ brand_tag, :snare      ] , [ :loop ] , [ :drumkit , :snare      , brand_tag ] ),
        Folder.new( [ brand_tag, :ride       ] , [ :loop ] , [ :drumkit , :ride       , brand_tag ] ),
        Folder.new( [ brand_tag, :rim        ] , [ :loop ] , [ :drumkit , :rim        , brand_tag ] ),
        Folder.new( [ brand_tag, :crash      ] , [ :loop ] , [ :drumkit , :crash      , brand_tag ] ),
        Folder.new( [ brand_tag, :tom        ] , [ :loop ] , [ :drumkit , :tom        , brand_tag ] ),
        Folder.new( [ brand_tag, :clave      ] , [ :loop ] , [ :drumkit , :clave      , brand_tag ] ),
        Folder.new( [ brand_tag, :bongo      ] , [ :loop ] , [ :drumkit , :bongo      , brand_tag ] ),
        Folder.new( [ brand_tag, :shaker     ] , [ :loop ] , [ :drumkit , :shaker     , brand_tag ] ),
        Folder.new( [ brand_tag, :mallet     ] , [ :loop ] , [ :drumkit , :mallet     , brand_tag ] ),
        Folder.new( [ brand_tag, :wood       ] , [ :loop ] , [ :drumkit , :wood       , brand_tag ] ),
        Folder.new( [ brand_tag, :stick      ] , [ :loop ] , [ :drumkit , :stick      , brand_tag ] ),
        Folder.new( [ brand_tag, :cow        ] , [ :loop ] , [ :drumkit , :cow        , brand_tag ] ),
        Folder.new( [ brand_tag, :maraca     ] , [ :loop ] , [ :drumkit , :maraca     , brand_tag ] ),
        Folder.new( [ brand_tag, :fx         ] , [ :loop ] , [ :drumkit , :fx         , brand_tag ] ),
        Folder.new( [ brand_tag, :percussion ] , [ :loop ] , [ :drumkit , :percussion , brand_tag ] ),
    ]
end

$folders += brand_drum_kit( :roland_tr808 )
$folders += brand_drum_kit( :roland_mc909 )
$folders += brand_drum_kit( :yamaha_rx120 )
$folders += brand_drum_kit( :chipshop )

$folders += help_instrument( :roland_jupiter8)
$folders += help_instrument( :moog )

$folders += help_loop( :dnb        )
$folders += help_loop( :dub        )
$folders += help_loop( :jazz       )
$folders += help_loop( :noise      )
$folders += help_loop( :breakbeat  )
$folders += help_loop( :hiphop     )
$folders += help_loop( :funkdisco  )
$folders += help_loop( :ambient    )
$folders += help_loop( :vinyl      )
$folders += help_loop( :fx         )
$folders += help_loop( :pads       )
$folders += help_loop( :lead       )
$folders += help_loop( :bass       )
$folders += help_loop( :vocal      )
$folders += help_loop( :drumkit    )
$folders += help_loop( :kick       )
$folders += help_loop( :percussion )
$folders += help_loop( :glitch     )
$folders += help_loop( :deep )

$folders += meta_folders_bpm
$folders += folder_tags.keys.map do |item|
    Folder.new([ item ])
end
