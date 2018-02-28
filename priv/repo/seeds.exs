# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Congress.Repo.insert!(%Congress.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Congress.Repo
alias Congress.Bill

bills = MapSet.new(["s419", "hr1892", "hr518", "hr1362", "s178", "hr3949", "hr375", "hr374", "hjres111",
	          "hr274", "s371", "hr1242", "hjres69", "hr2810", "hjres67", "hjres66", "hr2228", "hr560",
	          "hr1370", "hjres83", "hr657", "hr3819", "hr39", "hr366", "s1616", "s1617", "sjres1",
	          "hr1", "hr1679", "hr954", "hjres76", "hr2331", "s1266", "hjres99", "hr353", "hr510",
	          "s117", "s114", "hr195", "hr194", "s190", "hr863", "s920", "s496", "s1866", "s327",
	          "hr582", "s652", "hr2430", "hr534", "hr1616", "hr2142", "sjres35", "hr873", "sjres36",
	          "sjres30", "hr1117", "hr2210", "s84", "s1083", "hr3823", "s442", "s139", "hr3732",
	          "hr339", "s1766", "hr609", "hr1329", "s544", "hr601", "hr2288", "hr4641", "hr3243",
	          "hr3031", "hr228", "hr2611", "sjres49", "hr2266", "hr72", "hr3110", "hr2989", "hr1238",
	          "hr2519", "s305", "hr244", "hr321", "hjres37", "hjres38", "hr699", "s810", "s583",
	          "s585", "s1532", "hr3298", "hr4374", "s1536", "hr3759", "hr1228", "hr984", "hr255",
	          "hr1301", "s504", "hr1306", "hr624", "hjres43", "hjres42", "hjres41", "hjres40",
	          "s1393", "hjres44", "hr1927", "s2273", "hr4661", "hr4708", "s782", "hr381", "hr3364",
	          "hr304", "sjres34", "hjres123", "hr267", "hr1545", "s1094", "hr3218", "hjres57",
	          "hjres58", "s1141", "s534"])

Enum.each bills, fn x ->
	Repo.insert! %Bill{bill_slug: x, congress: 115}
end
