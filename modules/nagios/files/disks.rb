# disks.rb
# Facts listing disks


Facter.add("disks") do
    setcode do
        %x{/bin/df -P|/bin/grep ^/dev|/usr/bin/awk '{print $1}'|/usr/bin/tr "\n" ","|/bin/sed 's/,$//'}.chomp
    end
end

