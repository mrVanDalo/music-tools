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


# todo : only put in the folder the stuff which is not in the other folders
class Folder

    attr_accessor :include
    attr_accessor :exclude
    attr_accessor :folder_tags

    # include : included tags
    # exclude : excluded tags
    def initialize(  include_tags , exclude_tags = [], folder_name = include_tags )
        @folder_tags = folder_name
        @include = include_tags
        @exclude = exclude_tags
    end

    def name
        Folder.create_folder_name( @folder_tags )
    end

    def self.create_folder_name( tags )
        return File.join( tags.map { |tag| tag.to_s } )
    end

    def self.parent_folders_names( folder_tags )
        parents = folder_tags.map do |tag|
            folder_tags.take( folder_tags.find_index( tag ))
        end
        parents
    end

    def belongs_to? ( sample )
        sample_tags = sample.tags 
        all_tags_included = ( @include - sample_tags).empty?
        no_exclude_tag = ( sample_tags - @exclude ).size == sample_tags.size

        return all_tags_included && no_exclude_tag
    end

end

load "sample-script-config.rb"
load "sample-script-tags.rb"

# need $folders
# need $all_tags

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
        sample_collection[ folder.folder_tags ] = []
    end

    samples.each do |sample|
        $folders.each do |folder|
            if (folder.belongs_to?( sample))
                sample_collection[ folder.folder_tags ] += [sample]
            end
        end
    end
    return sample_collection
end


def clean_parent_folders! ( sample_collection )
    sample_collection.keys.map do |folder_tags|
        samples = sample_collection[ folder_tags ]
        Folder.parent_folders_names( folder_tags ).each do | parent_folder_tags |
            parent_samples = sample_collection[ parent_folder_tags ]
            if parent_samples
                puts "stripped #{folder_tags} : #{parent_folder_tags}"
                sample_collection[ parent_folder_tags ] = ( parent_samples - samples )
            else
                puts "nothing found for striped #{folder_tags} :  #{parent_folder_tags}"
            end
        end
    end
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
    sample_collection.each do |folder_tags, values|
        depth = get_depth(values)
        values.each do |sample|
            sample_result += [
                {
                    :folder => File.join( $target_dir, Folder.create_folder_name( folder_tags )),
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
clean_parent_folders!( sample_collection )
sample_directives = create_link_directives( sample_collection )

puts " directives : #{sample_directives.size}"
sample_directives.each do |directive|
    FileUtils.mkdir_p directive[:folder]
    FileUtils.ln(
        directive[:source], 
        File.join( directive[:folder], directive[:target]),
        :verbose => false
    )
end

