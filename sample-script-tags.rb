


def tag_help( prefix, suffix)
    [ '-', '_', ' ', '.', '', '#'].map do |separator|
        "#{prefix}#{separator}#{suffix}"
    end
end

# need to filter out files which are loops from drum/kick (for example)
# tags which will not result in a folder
meta_tags = {
    :roland_tr808 => tag_help( 'tr', '808'),
    :roland_mc909 => tag_help( 'mc', '909'),
    :roland_mc202 => tag_help( 'mc', '202'),
    :yamaha_rx120 => tag_help( 'rx', '120'),
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
    :cymabl  => %w( cym zym                       ) ,
    :wood    => %w( wood                          ) ,
    :whistle => %w( whistle                       ) ,
    :stick   => %w( stick                         ) ,
    :cow     => %w( cow bell                      ) ,
}

# to filter out bpm
meta_tags_bpm = (90..200).map do |bpm|
    { "#{bpm}bpm" => tag_help( bpm, "bpm" ) }
end
meta_tags_bpm    = meta_tags_bpm.reduce( {}, :merge )
meta_folders_bpm = meta_tags_bpm.keys.map do |tag|
    Folder.new([ :loop, tag ])
end

# tags which will result in a folder (:all)
folder_tags = {
    :vinyl        => %w( vinyl                       ) ,
    :pulse        => %w( pulse                       ) ,
    :drumkit      => %w( drumkit drum kit            ) ,
    :percussion   => %w( percussion perc             ) ,
    :loop         => %w( loop                        ) ,
    :instrument   => %w( instrument                  ) ,
    :keyboard     => %w( keyboard keys               ) ,
    :breakbeat    => %w( breakbeat                   ) ,
    :guitar       => %w( guitar                      ) ,
    :groove       => %w( groove groovy               ) ,
    :minimal      => %w( minimal glitch              ) ,
    :scratch      => %w( scratch turntabl            ) ,
    :reverse      => %w( reverse                     ) ,
    :jazz         => %w( jazz swing                  ) ,
    :brass        => %w( brass tuba                  ) ,
    :rhodes       => %w( wurly wurlitz rhodes        ) ,
    :strings      => %w( string pizzi                ) ,
    :synth        => %w( synth                       ) ,
    :oneshots     => %w( oneshot shot                ) ,
    :pads         => %w( pad atmo                    ) ,
    :lead         => %w( lead                        ) ,
    :bass         => %w( bass                        ) ,
    :vocal        => %w( vocal vox female male human ) ,
    :fx           => %w( fx                          ) ,
    :sweep        => %w( woosh sweep                 ) ,
    :funkdisco    => %w( disco funk                  ) ,
    :robotvocoder => %w( vocoder robot               ) ,
    :piano        => %w( piano keyboard              ) ,
    :organ        => %w( organ                       ) ,
    :deep         => %w( deep                        ) ,
}

# tags to extract from sample Map( TagName , List( StringMatches ) )
$all_tags = folder_tags.merge( meta_tags ).merge( meta_tags_bpm )

# folders which will be created List( List( FolderName ))
$folders = [
    # loops
    Folder.new( [ :loop    , :drumkit ] ),
    Folder.new( [ :loop    , :bass ] ),
    Folder.new( [ :loop    , :kick ] ),
    Folder.new( [ :loop    , :percussion ] ),
    # drum kits
    Folder.new( [ :drumkit , :bass ] , [ :loop ] ),
    Folder.new( [ :kick            ] , [ :loop ] ,  [ :drumkit , :kick    ] ),
    Folder.new( [ :hihat           ] , [ :loop ] ,  [ :drumkit , :hihat   ] ),
    Folder.new( [ :clap            ] , [ :loop ] ,  [ :drumkit , :clap    ] ),
    Folder.new( [ :snare           ] , [ :loop ] ,  [ :drumkit , :snare   ] ),
    Folder.new( [ :ride            ] , [ :loop ] ,  [ :drumkit , :ride    ] ),
    Folder.new( [ :rim             ] , [ :loop ] ,  [ :drumkit , :rim     ] ),
    Folder.new( [ :crash           ] , [ :loop ] ,  [ :drumkit , :crash   ] ),
    Folder.new( [ :tom             ] , [ :loop ] ,  [ :drumkit , :tom     ] ),
    Folder.new( [ :clave           ] , [ :loop ] ,  [ :drumkit , :clave   ] ),
    Folder.new( [ :bongo           ] , [ :loop ] ,  [ :drumkit , :bongo   ] ),
    Folder.new( [ :shaker          ] , [ :loop ] ,  [ :drumkit , :shaker  ] ),
    Folder.new( [ :mallet          ] , [ :loop ] ,  [ :drumkit , :mallet  ] ),
    Folder.new( [ :wood            ] , [ :loop ] ,  [ :drumkit , :wood    ] ),
    Folder.new( [ :whistle         ] , [ :loop ] ,  [ :drumkit , :whistle ] ),
    Folder.new( [ :stick           ] , [ :loop ] ,  [ :drumkit , :stick   ] ),
    Folder.new( [ :cow             ] , [ :loop ] ,  [ :drumkit , :cow     ] ),
    Folder.new( [ :cymbal          ] , [ :loop ] ,  [ :drumkit , :cymbal  ] ),
    # brands
    # roland
    Folder.new( [ :roland_tr808           ] , [ :loop ] , [ :drumkit, :roland_tr808 ]   ),
    Folder.new( [ :roland_tr808, :kick    ] , [ :loop ] , [ :drumkit , :roland_tr808, :kick    ] ),
    Folder.new( [ :roland_tr808, :hihat   ] , [ :loop ] , [ :drumkit , :roland_tr808, :hihat   ] ),
    Folder.new( [ :roland_tr808, :clap    ] , [ :loop ] , [ :drumkit , :roland_tr808, :clap    ] ),
    Folder.new( [ :roland_tr808, :snare   ] , [ :loop ] , [ :drumkit , :roland_tr808, :snare   ] ),
    Folder.new( [ :roland_tr808, :ride    ] , [ :loop ] , [ :drumkit , :roland_tr808, :ride    ] ),
    Folder.new( [ :roland_tr808, :rim     ] , [ :loop ] , [ :drumkit , :roland_tr808, :rim     ] ),
    Folder.new( [ :roland_tr808, :crash   ] , [ :loop ] , [ :drumkit , :roland_tr808, :crash   ] ),
    Folder.new( [ :roland_tr808, :tom     ] , [ :loop ] , [ :drumkit , :roland_tr808, :tom     ] ),
    Folder.new( [ :roland_tr808, :clave   ] , [ :loop ] , [ :drumkit , :roland_tr808, :clave   ] ),
    Folder.new( [ :roland_tr808, :bongo   ] , [ :loop ] , [ :drumkit , :roland_tr808, :bongo   ] ),
    Folder.new( [ :roland_tr808, :shaker  ] , [ :loop ] , [ :drumkit , :roland_tr808, :shaker  ] ),
    Folder.new( [ :roland_tr808, :mallet  ] , [ :loop ] , [ :drumkit , :roland_tr808, :mallet  ] ),
    Folder.new( [ :roland_tr808, :wood    ] , [ :loop ] , [ :drumkit , :roland_tr808, :wood    ] ),
    Folder.new( [ :roland_tr808, :whistle ] , [ :loop ] , [ :drumkit , :roland_tr808, :whistle ] ),
    Folder.new( [ :roland_tr808, :stick   ] , [ :loop ] , [ :drumkit , :roland_tr808, :stick   ] ),
    Folder.new( [ :roland_tr808, :cow     ] , [ :loop ] , [ :drumkit , :roland_tr808, :cow     ] ),
    Folder.new( [ :roland_tr808, :cymbal  ] , [ :loop ] , [ :drumkit , :roland_tr808, :cymbal  ] ),

    Folder.new( [ :yamaha_rx120], [ :loop ], [ :drumkit, :yamaha_rx120] ),
    Folder.new( [ :roland_mc202], [ :loop ], [ :synth  , :roland_mc202] ),
    Folder.new( [ :roland_mc909], [ :loop ], [ :sampler, :roland_mc909] ),
]
$folders += meta_folders_bpm
$folders += folder_tags.keys.map do |item|
    Folder.new([ item, :all ])
end
