#! /usr/bin/env ruby

require 'open-uri'
require 'json'

a_or_b = nil

list_json = `gcloud compute firewall-rules list --format=json`
hash = JSON.load(list_json)
hash.each do |data|
    a_or_b = "b" if data["name"].start_with?("block-cost-country-a-")
    a_or_b = "a" if data["name"].start_with?("block-cost-country-b-")
end

a_or_b = "a" if a_or_b == nil

['cn', 'au'].each do |country|
    url = 'https://ipv4.fetus.jp/' + country + '.txt'

    ips = []
    open(url) do |file|
        file.each_line {|line|
            next if line.chomp.start_with?("#")
            next if line.chomp.empty?
            ips.push(line.chomp)
        }
    end

    cnt = 1

    ips.each_slice(254) do |ary|
        name = 'block-cost-country-' + a_or_b + '-' + country + ('-%03d' % cnt)

        cmd_create = [
            'gcloud compute firewall-rules create',
            name,
            '--action=deny',
            '--rules=all',
            '--priority=900',
            '--source-ranges=' + ary.join(","),
        ]
        cmdstr_create = cmd_create.join(" ")
        puts cmdstr_create
        system cmdstr_create

        cnt += 1
    end

    list_json = `gcloud compute firewall-rules list --format=json`
    hash = JSON.load(list_json)
    delete_names = []
    hash.each do |data|
        if (a_or_b == "a" && data["name"].start_with?("block-cost-country-b-")) ||
            (a_or_b == "b" && data["name"].start_with?("block-cost-country-a-"))
            delete_names.push(data["name"])
        end
    end

    if delete_names != []
        cmd_create = [
            'gcloud compute firewall-rules delete',
            delete_names.join(" "),
            '--quiet',
        ]
        cmdstr_create = cmd_create.join(" ")
        puts cmdstr_create
        system cmdstr_create
    end
end
