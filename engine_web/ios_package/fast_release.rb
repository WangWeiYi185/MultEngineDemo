require "Pathname"

# 上传到cocoapod 私有仓
docment = <<-DOC
    MARK : 添加fast_release.rb, 到spec同级文件夹
           --input 则为选择用户输入
DOC

version = <<-VER
--------------------------------------
|   input    |        action          |
|   1        |        主动输入         |
|   2        |        最后一位累加      |
--------------------------------------
VER

sepc_input_name = <<-VER
--------------------------------------
|   input    |        action          |
|   1        |        主动输入         |
|   2        |        默认            |
--------------------------------------
VER



# jump last version
def version_split(version)
  version.delete!("'\"").strip!
  nums = version.split(".")
  num = nums.last.to_i(base = 10) + 1
  ver = ""
  nums.delete_at(nums.length - 1)
  nums.each do |sub_str|
    ver << sub_str + "."
  end
  ver << "#{num}"
end

user_input = nil


shift = ARGV.shift
user_input = shift.include?("input") if shift
user_statement = (shift.include?("version") ? ARGV[0] : shift) if  shift

puts "开始打包版本: #{user_statement}"

#mark global
sepc_file = nil
repo_name = nil
new_content = ""
news_version = nil
repo_private_path = nil
current_basename = nil

Dir.foreach("./") do |file|
  file_obj = Pathname.new(file)
  ext = file_obj.extname

  if ext.include?("podspec")
    sepc_file = File.open(file, "r")
    current_basename = file.split(".").first
  end
end

raise "没有找到podspec文件，请检查你的大脑" unless current_basename

sepc_file.each do |line|
  if line.include?(".version") && !line.include?("{")
    version_show = line.split("=")
    news_version =  user_statement ? user_statement : version_split(version_show.last)
    if user_input
      puts version
      print "请输入选择: "
      if gets.include?("1")
        print "请输入版本："
        news_version = gets
        news_version.strip!
      end
    end
    new_content << "#{version_show.first}= '#{news_version}'\n"
  else
    new_content << (line.chomp! + "\n")
  end
end

p = File.open(sepc_file.path, "w")
p.write(new_content)
p.close

if shift.include?("version")
  print "指定版本号不打印tag"
else
  `git tag #{news_version}`
  `sleep 2`
  `git push --tags`
end
#推荐使用open3.但并不想引入导致团队成员拉取依赖【open3 捕获shell输出异常，并进行串行执行】
#https :/ / cloud.tencent.com / developer / section / 1379056

`rm -f temp.txt`
`pod repo > temp.txt`

user_input_name = ""
if user_input
    puts sepc_input_name
    print "请输入选择: "
    if gets.include?("1")
        print "请输入私有库名称："
        user_input_name = gets
    end
end
keys = ["http://gitlab.qima-inc.com/guang-app-lib/cocoaPodsSepcs",
        "http://gitlab.qima-inc.com/guang-app-lib/cocoaPodsSepcs.git",
        "git@gitlab.qima-inc.com:guang-app-lib/cocoaPodsSepcs.git"]
keys = [] if user_input_name.length > 0

temp_all_content = File.read("temp.txt")
temp_contents = temp_all_content.split("\n\n")

temp_contents.each do |temp_sub_content|
  if temp_sub_content.include?("- URL:") && temp_sub_content.include?("- Type:") && temp_sub_content.include?("- Path:")
    temp_sub_contents = temp_sub_content.split("\n")
    repo_name = nil
    path = nil
    url = nil
    temp_sub_contents.each do |line|
      repo_name = line.strip unless line.include?(":")
      url = line.split(":  ").last.strip unless !line.include?("URL:")
      path = line.split(": ").last.strip unless !line.include?("Path:")
    end

    if user_input_name && repo_name.eql?(user_input_name)
      repo_private_path = path
    elsif keys.include?(url)
      repo_private_path = path
    else
    end
  end
end
`rm -f temp.txt`
raise "未找到私有库路径" unless repo_private_path

system "cd #{repo_private_path} && git pull"

repo_absolut_path = repo_private_path + "/#{current_basename}" + "/#{news_version}"
repo_private_obj = Pathname.new(repo_absolut_path)
raise "pull 之后 #{repo_absolut_path}下，存在 #{news_version}版本" unless !repo_private_obj.exist?

`mkdir #{news_version}`
`cp #{sepc_file.path} #{news_version}`
repo_cp_path = repo_private_path + "/#{current_basename}"
system "cp -r #{news_version} #{repo_cp_path}"
`sleep 3`
`rm -rf #{news_version}`
`sleep 3`

system "cd #{repo_private_path} && git add ."
system "cd #{repo_private_path} && git commit -m \"jump version\""
system "cd #{repo_private_path} && git push"
`sleep 3`

puts "脚本执行完毕，但是push不一定执行完成，需要稍等几秒钟"
