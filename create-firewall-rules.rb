#! /usr/bin/env ruby

require 'open-uri'

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
        name = 'block-cost-country-' + country + ('-%03d' % cnt)

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

end
