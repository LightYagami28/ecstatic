require 'rubygems'
require 'tenjin'
require 'optparse'
require 'yaml'
require 'activesupport'
require 'rake'
require 'rake/clean'
require 'find'
require 'open3'

module Ecstatic
  class Site
    attr_accessor :pages, :files, :sitedir, :templatesdir, :datadir, :filesdir,
                  :default_layout, :navfile, :navhash, :sitetitle, :modelsdir

    def initialize(params = {})
      @sitedir        = params[:sitedir] || "site"
      @default_layout = params[:layoutfile] || "standard.rbhtml"
      @filesdir       = params[:filesdir] || "files"
      @modelsdir      = params[:modelsdir] || "models"
      @sitetitle      = params[:sitetitle] || ""
      @templatesdir   = params[:templatesdir] || "."
      @datadir        = params[:datadir] || "."
      @navfile        = params[:navfile] || "sitenav.yaml"
      index           = params[:indexfile] || "siteindex.yaml"

      siteindex = YAML.load(File.read(index))

      # Load user-defined data models
      load_models

      # Construct navigation map
      @navhash = load_nav(@navfile)

      # Construct list of pages
      @pages = build_pages(siteindex)

      # Construct hash of files
      @files = build_files
    end

    def tasks
      CLEAN.include(sitedir)
      directory sitedir

      pages.each_pair do |dest, page|
        file dest => ([page.templatefile, page.layoutfile, navfile] + page.datafiles) do
          output = page.render
          File.write(dest, output)
          $stderr.puts "rendered #{dest}"
        end
      end

      desc "Build website in '#{sitedir}' directory."
      task :website => [sitedir] + pages.keys + files.keys
    end

    private

    def load_models
      Find.find(@modelsdir) do |f|
        require f unless f == @modelsdir
      end
    end

    def load_nav(navfile)
      return unless navfile

      YAML.load(File.open(navfile).read)
    end

    def build_pages(siteindex)
      pages = {}
      siteindex.each do |p|
        dest = File.join(@sitedir, p['url'])
        pages[dest] = Page.new({
                                 url: p['url'],
                                 title: p['title'],
                                 layoutfile: p['layout'] || @default_layout,
                                 templatefile: File.join(@templatesdir, p['template']),
                                 format: (p['format'] ? p['format'].to_sym : :html),
                                 navhash: @navhash,
                                 datafiles: build_datafiles(p['data'])
                               })
      end
      pages
    end

    def build_datafiles(data)
      if data.is_a?(Array)
        data.map { |x| File.join(@datadir, x) }
      elsif data.is_a?(String)
        [File.join(@datadir, data)]
      else
        []
      end
    end

    def build_files
      files = {}
      Find.find(@filesdir) do |f|
        next if f == @filesdir

        base = f.gsub(/^[^\/]*\//, "")
        files[File.join(@sitedir, base)] = f
      end
      files
    end
  end

  class Page
    attr_accessor :datafiles, :contexthash, :layoutfile, :templatefile, :url, :format, :title, :navhash

    def initialize(params)
      @templatefile = params[:templatefile]
      @title        = params[:title]
      @format       = params[:format]
      @layoutfile   = params[:layoutfile]
      @navhash      = params[:navhash]
      @url          = params[:url]
      @datafiles    = params[:datafiles] || []

      # Get context from data files
      @contexthash = build_context
    end

    def render
      engine = Tenjin::Engine.new(cache: false, escapefunc: 'Ecstatic.no_escape')
      context = Tenjin::Context.new(@contexthash)
      markdown_output = engine.render(@templatefile, context)

      formatted_output = format_output(markdown_output)
      layout_output(formatted_output, engine)
    end

    private

    def build_context
      context = {}
      @datafiles.each do |file|
        yaml = load_yaml(file)
        yaml.each_pair do |key, val|
          model = key.singularize.capitalize
          context[key] = initialize_model(model, val)
        end
      end
      context
    end

    def load_yaml(file)
      yamltext = File.read(file)
      yaml = YAML.load(yamltext)
      yaml.is_a?(Hash) ? yaml : { File.basename(file, File.extname(file)) => yaml }
    end

    def initialize_model(model, val)
      begin
        mod = Object.const_get(model)
        mod.from_array(val)
      rescue => e
        $stderr.puts("Unable to initialize #{model} for #{val}")
        raise
      end
    end

    def format_output(markdown_output)
      cmd = case @format
            when :html then "pandoc -r markdown -w html --smart"
            when :latex then "pandoc -r markdown -w latex --smart"
            when :plain then "cat"
            end

      Open3.popen3(cmd) do |stdin, stdout, stderr|
        stdin.write(markdown_output)
        stdin.close
        stdout.read
      end
    end

    def layout_output(formatted_output, engine)
      if @layoutfile
        engine.render(@layoutfile, {'_contents' => formatted_output, '_nav' => @navhash, '_url' => @url})
      else
        formatted_output
      end
    end
  end

  # Escape functions
  def no_escape(str)
    str
  end

  def mkmenu(menu, url = nil)
    return "" unless menu

    _buf = ["<ul class=\"nav\">"]
    menu.each do |item|
      if item.is_a?(Hash)
        item.each_pair do |k, v|
          if v.is_a?(Array)
            _buf << "<li>#{k}#{mkmenu(v, url)}</li>"
          else
            selected = (url == v ? " class=\"selected\"" : "")
            _buf << "<li#{selected}><a href=#{v}>#{k}</a></li>"
          end
        end
      end
    end
    _buf << "</ul>"
    _buf.join("\n")
  end

  module_function :mkmenu, :no_escape
end
