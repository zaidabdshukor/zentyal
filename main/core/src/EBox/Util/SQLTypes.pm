# Copyright (C) 2012 eBox Technologies S.L.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License, version 2, as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

package EBox::Util::SQLTypes;

use warnings;
use strict;
no strict 'refs';

use Socket;

sub storer
{
    my ($type, $value) = @_;

    my $storer = "_${type}_storer";
    return &$storer($value);
}

sub acquirer
{
    my ($type, $field) = @_;

    my $acquirer = "_${type}_acquirer";
    return &$acquirer($field);
}

sub _IPAddr_storer
{
    my ($value) = @_;

    return unpack ('N', inet_aton($value));
}

sub _IPAddr_acquirer
{
    my ($field) = @_;

    return "INET_NTOA($field) AS $field";
}

sub _MACAddr_storer
{
    my ($value) = @_;

    $value =~ s/://g;
    return '0x' . $value;
}

sub _MACAddr_acquirer
{
    my ($field) = @_;

    my $hex = "HEX($field)";
    my $concat = "CONCAT_WS(':'";
    for my $i (0..5) {
        $concat .= ", MID($hex, " . ($i*2 + 1) . ', 2)';
    }
    $concat .= ") AS $field";

    return $concat;
}

1;
