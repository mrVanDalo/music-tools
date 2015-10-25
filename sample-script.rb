
$samples_dir = '/home/renoise/Samples'
$target_dir = '/home/renoise/Renoise/User Library/Samples'

# need to filter out files which are loops from drum/kick (for example)


# tags which will not result in a folder
$meta_tags = {
    :tr808 => [ 'tr808' ],
    :mc909 => [ 'mc-909', 'mc909' ],
    :kick                => [ "kick", "bassdrum"],
    :hihat               => [ "hihat", "hat", 'hit','openhi', 'closedhi'],
    :clap                => [ "clap"],
    :snare               => [ "snare"],
    :ride                => [ "ride"],
    :rim                 => [ 'rim'],
    :crash               => [ "crash", "cymbal", 'cym'],
    :tom                 => ['tom'],
}

# to filter out pbm
$meta_tags_bpm = (90..300).map do |bpm|
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
    [ :loop, tag ]
end

# tags which will result in a folder (:all)
$folder_tags = {
    :vinyl               => [ 'vinyl' ],
    :pulse               => [ 'pulse' ],
    :drumkit             => [ "drumkit", 'drum', 'kit'],
    :percussion_acoustic => [ "clave", "tom", "bongo", "conga", "shaker", "mallet", "wood", "whistle", 'stick', 'cow'],
    :percussion_mixed    => [ "percussion", "perc"],
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
    [ :loop    , :drumkit             ] ,
    [ :loop    , :bass ] ,
    [ :loop    , :kick ] ,
    [ :loop    , :percussion_acoustic ] ,
    [ :loop    , :percussion_mixed    ] ,
    [ :drumkit , :kick                ] ,
    [ :drumkit , :hihat               ] ,
    [ :drumkit , :clap                ] ,
    [ :drumkit , :snare               ] ,
    [ :drumkit , :ride                ] ,
    [ :drumkit , :rim                 ] ,
    [ :drumkit , :crash               ] ,
    [ :drumkit , :tom                 ] ,
    [ :drumkit , :tr808               ] ,

]
$folders += $meta_folders_bpm
$folders += $folder_tags.keys.map do |item|
    [ item, :all ]
end

def folder_name( tags )
    return File.join( tags.map { |tag| tag.to_s } )
end

def belongs_to_folder? ( tags , sample )
    sample_tags = sample.tags + [:all]
    return (tags - sample_tags).empty?
end

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


$sample_collection = {}
$folders.each do |folder|
    $sample_collection[ folder_name( folder ) ] = []
end

find_samples($samples_dir).each do |sample|
    $folders.each do |folder|
        if (belongs_to_folder?( folder, sample))
            $sample_collection[ folder_name ( folder ) ] += [sample]
        end
    end
end

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

$sample_result = []

#puts $sample_collection

$sample_collection.each do |key, values|
    depth = get_depth(values)
    values.each do |sample|
        $sample_result += [
            {
                :folder => File.join( $target_dir, key ),
                :target => sample.target(depth),
                :source => sample.path,
            }
        ]
    end
end

require 'fileutils'

FileUtils.rm_r $target_dir

$sample_result.each do |sample|
    FileUtils.mkdir_p sample[:folder]
    FileUtils.ln(
        sample[:source], 
        File.join( sample[:folder], sample[:target]), 
        :verbose => true
    )
end

#p $samples

#$folders.each { |folder| puts folder_name( folder ) }
