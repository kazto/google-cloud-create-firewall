#! /usr/bin/env ruby

['cn', 'au'].each do |country|
    ips = File.open(country + '.txt').readlines.map{|v| v.chomp}
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
