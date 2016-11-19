# Title: Include Code Tag for Jekyll
# Author: Brandon Mathis http://brandonmathis.com
# Description: Import files on your filesystem into any blog post as embedded code snippets with syntax highlighting and a download link.
# Configuration: You can set default import path in _config.yml (defaults to code_dir: downloads/code)
#
# Syntax {% include_code path/to/file %}
#
# Example 1:
# {% include_code javascripts/test.js %}
#
# This will import test.js from source/downloads/code/javascripts/test.js
# and output the contents in a syntax highlighted code block inside a figure,
# with a figcaption listing the file name and download link
#
# Example 2:
# You can also include an optional title for the <figcaption>
#
# {% include_code Example 2 javascripts/test.js %}
#
# will output a figcaption with the title: Example 2 (test.js)
#

require 'pathname'

module Jekyll

  class IncludeCodeTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      if markup.strip =~ /(\/*\S+)/i
        @file = $1
      end
      super
    end

    def render(context)
      inputFile = File.open(@file, "rb")
      source = inputFile.read
    end
  end

end

Liquid::Template.register_tag('include_code', Jekyll::IncludeCodeTag)
