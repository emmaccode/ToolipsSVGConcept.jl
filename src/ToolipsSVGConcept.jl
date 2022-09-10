module ToolipsSVGConcept
using Toolips
using ToolipsSession
using ToolipsDefaults: cursor
import Toolips: AbstractComponent
import ToolipsSession: on

function circle(name::String, p::Pair{String, <:Any} ...; args ...)
    Component(name, "circle", p ..., args ...)::Component{:circle}
end

function circle(name::String, x::Any, y::Any, r::Any)
    circle(name, cx = x, cy = y, r = r, stroke = "black", "stroke-width" => 5)
end


function circle(name::String, x::Any, y::Any, z::Any, r::Any)

end

"""
home(c::Connection) -> _
--------------------
The home function is served as a route inside of your server by default. To
    change this, view the start method below.
"""
function home(c::Connection)
    mysvgwindow = svg("mysvgwindow", width = 100, height = 100)
    curs = cursor("svgcursor")
    colorvec = ["red", "green", "orange", "pink", "blue"]
    on(c, mysvgwindow, "click") do cm::ComponentModifier
        cursx = cm[curs]["x"]
        cursy = cm[curs]["y"]
        if "newcircle" in keys(cm.rootc)
            cm["newcircle"] = "cx" => cursx
            cm["newcircle"] = "cy" => cursy
            cm["newcircle"] = "stroke" => colorvec[rand(1:length(colorvec))]
        else
            mycirc = circle("newcircle", cursx, cursy, 10)
            on(c, mycirc, "click") do cm::ComponentModifier
                cm["mycircle"] = "r" => "20"
            end
            style!(mycirc, "transition" => 1seconds)
            set_children!(cm, mysvgwindow, [mycirc])
        end
    end
    bod = body("svgbody")
    push!(bod, mysvgwindow, curs)
    write!(c, bod)
end

fourofour = route("404") do c
    write!(c, p("404message", text = "404, not found!"))
end

routes = [route("/", home), fourofour]
extensions = Vector{ServerExtension}([Logger(), Files(), Session(), ])
"""
start(IP::String, PORT::Integer, ) -> ::ToolipsServer
--------------------
The start function starts the WebServer.
"""
function start(IP::String = "127.0.0.1", PORT::Integer = 8000)
     ws = WebServer(IP, PORT, routes = routes, extensions = extensions)
     ws.start(); ws
end
end # - module
