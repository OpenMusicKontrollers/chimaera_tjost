#!/usr/bin/env tjost

--[[
 * Copyright (c) 2015 Hanspeter Portner (dev@open-music-kontrollers.ch)
 *
 * This is free software: you can redistribute it and/or modify
 * it under the terms of the Artistic License 2.0 as published by
 * The Perl Foundation.
 *
 * This source is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * Artistic License 2.0 for more details.
 *
 * You should have received a copy of the Artistic License 2.0
 * along the source as a COPYING file. If not, obtain it from
 * http://www.perlfoundation.org/artistic_license_2_0.
--]]

id = require('id')

methods = {
	['/dump'] = tjost.plugin({name='write', path='stat.dump.osc'}),
	['/set'] = tjost.plugin({name='write', path='stat.evnt.osc'})
}

stream = tjost.plugin({name='net_in', uri='osc.udp://:3333', rtprio=60, unroll='full'}, function(time, path, ...)
	local meth = methods[path]
	if meth then
		meth(time, path, ...)
	end
end)
			
chim = tjost.plugin({name='net_out', uri='osc.udp://chimaera.local:4444'})

chim(0, '/sensors/movingaverage', 'ii', id(), 8)
--chim(0, '/sensors/interpolation', 'is', id(), 'none')
chim(0, '/sensors/interpolation', 'is', id(), 'quadratic')
--chim(0, '/sensors/interpolation', 'is', id(), 'catmullrom')
--chim(0, '/sensors/interpolation', 'is', id(), 'lagrange')
chim(0, '/engines/dump/enabled', 'ii', id(), 1)
chim(0, '/engines/dummy/enabled', 'ii', id(), 1)
chim(0, '/engines/dummy/redundancy', 'ii', id(), 1)
