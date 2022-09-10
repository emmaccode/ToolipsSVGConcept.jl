using Pkg; Pkg.activate(".")
using Toolips
using ToolipsSVGConcept

IP = "127.0.0.1"
PORT = 8000
ToolipsSVGConceptServer = ToolipsSVGConcept.start(IP, PORT)
