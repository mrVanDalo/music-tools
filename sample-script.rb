class Sample

    attr_accessor :path
    attr_accessor :tags
    attr_accessor :basepath
    attr_accessor :clear_path


    def initialize(basepath, path)
        @path = path
        @basepath = basepath
        @clear_path = @path[ basepath.size .. -1 ]
        @tags = $all_tags.map do |tag, values|
            result = []
            values.each do |regex|
                if @clear_path.downcase.include?(regex)
                    result = [tag]
                end
            end
            result
        end
        @tags.flatten!
    end

    def basename
        return File.basename( @path )
    end


    def target( depth = 1 )
        path = @path
        name = []
        (1 .. depth).each do |deep|
            name += [File.basename( path )]
            path = File.dirname( path )
        end
        name.reverse!
        return name.join("-")
    end

end


# todo : only put in the :all folder the stuff which is not in the other folders
class Folder

    attr_accessor :include
    attr_accessor :exclude

    # include : included tags
    # exclude : excluded tags
    def initialize(  include_tags , exclude_tags = [], folder_name = include_tags )
        @folder_name = folder_name
        @include = include_tags
        @exclude = exclude_tags
    end

    def name
        return File.join( @folder_name.map { |tag| tag.to_s } )
    end

    def belongs_to? ( sample )
        sample_tags = sample.tags + [:all]
        all_tags_included = ( @include - sample_tags).empty?
        no_exclude_tag = ( sample_tags - @exclude ).size == sample_tags.size

        return all_tags_included && no_exclude_tag
    end

end


$samples_dir = '/home/palo/samples'
$target_dir = '/home/palo/samples_sorted'

# need to filter out files which are loops from drum/kick (for example)

# tags which will not result in a folder
$meta_tags = {
    :tr808 => [ 'tr808' ],
    :roland_mc909 => [ 'mc-909', 'mc909' ],
    :roland_mc202 => [ 'mc-202', 'mc202' ],
    :yamaha_rx120 => [ 'rx-120', 'rx120' ],
    :kick  => [ "kick", "bassdrum"],
    :hihat => [ "hihat", "hat", 'hit','openhi', 'closedhi'],
    :clap  => [ "clap"],
    :snare => [ "snare"],
    :ride  => [ "ride"],
    :rim   => [ 'rim'],
    :crash => [ "crash", "cymbal", 'cym'],
    :tom   => ['tom'],
    :clave => [ "clave",],
    :bongo => [  "bongo", "conga", ],
    :shaker => [ "shaker", ],
    :mallet => [  "mallet", ],
    :wood => [ "wood", ],
    :whistle => [ "whistle", ],
    :stick => [ 'stick', ],
    :cow => [ 'cow', 'bell' ],
}

# to filter out pbm
$meta_tags_bpm = (90..200).map do |bpm|
    { "#{bpm}bpm" =>
      [
          "#{bpm}bpm",
          "#{bpm}-bpm",
          "#{bpm}_bpm",
          "#{bpm} bpm",
          "#{bpm}.bpm",
      ]
    }
end
$meta_tags_bpm = $meta_tags_bpm.reduce( {}, :merge )
$meta_folders_bpm = $meta_tags_bpm.keys.map do |tag|
    Folder.new([ :loop, tag ])
end

# tags which will result in a folder (:all)
$folder_tags = {
    :vinyl               => [ 'vinyl' ],
    :pulse               => [ 'pulse' ],
    :drumkit             => [ "drumkit", 'drum', 'kit'],
    :percussion => [ "percussion", "perc"],
    :loop                => [ "loop" ],
    :instrument          => [ "instrument"],
    :keyboard            => [ "keyboard", "keys"],
    :breakbeat           => [ "breakbeat"],
    :guitar              => [ "guitar"],
    :groove              => [ "groove", "groovy"],
    :minimal             => [ "minimal", "glitch"],
    :scratch             => [ "scratch", "turntabl"],
    :reverse             => [ "reverse"],
    :jazz                => [ "jazz", "swing"],
    :brass               => [ "brass", "tuba"],
    :rhodes              => [ "wurly", "wurlitz", "rhodes"],
    :strings             => [ "string", "pizzi"],
    :synth               => [ 'synth'],
    :oneshots            => [ "oneshot", "shot"],
    :pads                => [ "pad", 'atmo'],
    :lead                => [ "lead"],
    :bass                => [ "bass"],
    :vocal               => [ "vocal", "vox", "female", "male", "human"],
    :fx                  => [ "fx"],
    :sweep               => [ "woosh", "sweep"],
    :funkdisco           => [ "disco", "funk"],
    :robotvocoder        => [ "vocoder", "robot"],
    :piano               => [ 'piano', 'keyboard' ],
    :organ               => [ 'organ' ],
    :deep                => ['deep'],
}

# tags to extract from sample Map( TagName , List( StringMatches ) )
$all_tags = $folder_tags.merge( $meta_tags ).merge( $meta_tags_bpm )

# folders which will be created List( List( FolderName ))
$folders = [
    # loops
    Folder.new( [ :loop    , :drumkit ] ),
    Folder.new( [ :loop    , :bass ] ),
    Folder.new( [ :loop    , :kick ] ),
    Folder.new( [ :loop    , :percussion ] ),
    # drum kits
    Folder.new( [ :drumkit , :bass ], [ :loop ] ),
    Folder.new( [ :kick  ]  , [ :loop ], [ :drumkit , :kick  ]   ),
    Folder.new( [ :hihat ]  , [ :loop ], [ :drumkit , :hihat ]   ),
    Folder.new( [ :tr808 ]  , [ :loop ], [ :drumkit , :tr808 ]   ),
    Folder.new( [ :clap  ]  , [ :loop ], [ :drumkit , :clap  ]   ),
    Folder.new( [ :snare ]  , [ :loop ], [ :drumkit , :snare ]   ),
    Folder.new( [ :ride  ]  , [ :loop ], [ :drumkit , :ride  ]   ),
    Folder.new( [ :rim   ]  , [ :loop ], [ :drumkit , :rim   ]   ),
    Folder.new( [ :crash ]  , [ :loop ], [ :drumkit , :crash ]   ),
    Folder.new( [ :tom   ]  , [ :loop ], [ :drumkit , :tom   ]   ),
    Folder.new( [ :clave ]  , [ :loop ], [ :drumkit , :clave ]   ),
    Folder.new( [ :bongo ]  , [ :loop ], [ :drumkit , :bongo ]   ),
    Folder.new( [ :shaker ] , [ :loop ], [ :drumkit , :shaker ]  ),
    Folder.new( [ :mallet ] , [ :loop ], [ :drumkit , :mallet ]  ),
    Folder.new( [ :wood    ], [ :loop ], [ :drumkit , :wood ]    ),
    Folder.new( [ :whistle ], [ :loop ], [ :drumkit , :whistle ] ),
    Folder.new( [ :stick ]  , [ :loop ], [ :drumkit , :stick ]   ),
    Folder.new( [ :cow ]    , [ :loop ], [ :drumkit , :cow ]     ),
    # brands
    Folder.new( [ :yamaha_rx120], [ :loop ], [ :drumkit, :yamaha_rx120] ),
    Folder.new( [ :roland_mc202], [ :loop ], [ :synth  , :roland_mc202] ),
    Folder.new( [ :roland_mc909], [ :loop ], [ :sampler, :roland_mc909] ),
]
$folders += $meta_folders_bpm
$folders += $folder_tags.keys.map do |item|
    Folder.new([ item, :all ])
end


def find_samples(samples_dir)
    samples = []

    def is_propper_sample?( file ) 
        if File.ftype(file) != 'file'
            return false
        end

        if file.downcase.end_with? ("wav")
            return true
        end
        if file.downcase.end_with? ("flac")
            return true
        end

    end


    Dir.glob("#{samples_dir}/**/*") do |item|
        if is_propper_sample?(item)
            samples += [Sample.new(samples_dir, item)]
        end
    end

    return samples
end


def collect_samples( samples ) 
    sample_collection = {}
    $folders.each do |folder|
        sample_collection[ folder.name ] = []
    end

    samples.each do |sample|
        $folders.each do |folder|
            if (folder.belongs_to?( sample))
                sample_collection[ folder.name ] += [sample]
            end
        end
    end
    return sample_collection
end



def create_link_directives( sample_collection )

    require 'fileutils'

    def get_depth( values , depth = 1) 
        names = values.map do |sample|
            sample.target(depth)
        end
        if names.uniq.size == names.size
            return depth
        else
            return get_depth( values, depth + 1 )
        end
    end

    sample_result = []
    sample_collection.each do |key, values|
        depth = get_depth(values)
        values.each do |sample|
            sample_result += [
                {
                    :folder => File.join( $target_dir, key ),
                    :target => sample.target(depth),
                    :source => sample.path,
                }
            ]
        end
    end

    return sample_result
end

def clear_target_dir()
    require 'fileutils'
    if File.exist?( $target_dir )
        FileUtils.rm_r $target_dir
    end
end



#
# main
# ------------------------------------------------------------
clear_target_dir()

samples = find_samples($samples_dir)
sample_collection = collect_samples(samples)
sample_directives = create_link_directives( sample_collection )

sample_directives.each do |directive|
    FileUtils.mkdir_p directive[:folder]
    FileUtils.ln(
        directive[:source], 
        File.join( directive[:folder], directive[:target]),
        :verbose => true
    )
end

