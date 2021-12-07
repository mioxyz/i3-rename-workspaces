#!/bin/ruby
require 'json'

def findFocused(parent)
   if parent["focused"] then return parent end
   parent["nodes"].each do |child|
      maybe = findFocused child
      if maybe then return maybe end
   end
   return nil
end

node = findFocused JSON.parse %x[i3-msg -t get_tree]
sClass = node["window_properties"]["class"]

suggestions = []

case node["window_properties"]["class"]
   when "Alacritty"
      suggestions.push "[TERM]"

      # check if we are editing something with kakoune
      if node["window_properties"]["title"].match? "Kakoune" then
         suggestions.push("[K]")
         suggestions.push( "[K] #{node['window_properties']['title'].split('-').first.split(' ').first}")
      else
         suggestions.push "[T] #{node['name']}"
      end
   when "Chromium"
      suggestions.push "[W]"
      suggestions.push "[W] #{node['name']}"
   when "code-oss"
      suggestions.push "[C]"
      suggestions.push("[C] #{node['window_properties']['title'].split(' - ').first}")
end

suggestions.push node["name"]
suggestions.push "clear"

if !suggestions.include? node["window_properties"]["title"] then
   suggestions.push node["window_properties"]["title"]
end

if !suggestions.include? node["window_properties"]["instance"] then
   suggestions.push node["window_properties"]["instance"]
end

if !suggestions.include? node["window_properties"]["class"] then
   suggestions.push node["window_properties"]["class"]
end

if node["name"] != node["window_properties"]["title"] then
   suggestions.push "#{node['name']} | #{node['window_properties']['title']}"
   end
end

selection = %x[echo -e "#{suggestions.join("\n")}" | dmenu -fn 'Droid Sans Mono-14' -l 12]

JSON.parse(%x[i3-msg -t get_workspaces]).each do |workspace|   
   if (workspace['focused']) then
      number = workspace['name'][0]
      if ["clear", '\n', ''].include? selection.chomp then
         newName = number
      else
         newName = "#{number}:{#{number}} #{selection.chomp}"
      end
      %x[i3-msg 'rename workspace "#{workspace['name']}" to "#{newName}"']
      %x[sed -i '#{number}s/.*/#{newName}/' "/tmp/i3/workspace_names.txt"]
      exit(true)
   end
end

exit true

