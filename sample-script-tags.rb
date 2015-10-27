
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
    # brands
    :roland_tr808    => match_glue( 'tr', '808'),
    :roland_mc909    => match_glue( 'mc', '909'),
    :roland_mc202    => match_glue( 'mc', '202'),
    :roland_jupiter8 => match_glue( 'jp', '8') + match_glue( 'jupiter' , '8' ),
    :moog            => %w( moog ),
    :yamaha_rx120    => match_glue( 'rx', '120'),
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
$folders += drum_kit( :roland_tr808 , $drum_tags )
$folders += drum_kit( :roland_mc909 , $drum_tags )
$folders += drum_kit( :roland_mc202 , $drum_tags )
$folders += drum_kit( :yamaha_rx120 , $drum_tags )



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

puts $folders.size
$folders.flatten!
puts $folders.size
$folders.uniq!{ |l| l.uniq_id }
puts $folders.size
