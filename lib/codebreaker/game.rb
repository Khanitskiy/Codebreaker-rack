require "yaml"

module Codebreaker
  class Game

    CODE_SIZE = 4

    attr_accessor :attempts, :gamer_name, :user_id, :user_code, :hint_code
    attr_reader   :answer, :attempts_count, :secret_code

    def initialize(user_name = '')
      @secret_code = ""
      @user_name = user_name
      @attempts_count = 0
      @hint_code = '****'
      @attempts = ''
      @user_id = rand.to_s[2..11]
      @answer = ''
    end
 
    def start
      @secret_code = CODE_SIZE.times.map{ |i| i = Random.new.rand(1..6).to_s }
    end

    def user_code_split(arg)
      @user_code = arg.split("")
    end

    def comparison_codes(user_id, user_code)
      user_info = get_user_info(user_id)
      if user_info[0][:secret_code] == user_code.split("")
        self.save_result(user_id)
        self.update_condition(true, user_id)
      elsif user_info[0][:attempts_count] == user_info[0][:attempts]-1
        self.update_condition(false, user_id)
      end
      false
    end

    def get_secred_code(user_id) 
      YAML.load(File.open("./data/#{user_id}.txt"))[0][:secret_code]
    end


    def create_answer(user_id)
      sc = self.get_secred_code(user_id)
      user_code = @user_code.dup
      for i in 0...CODE_SIZE
      if sc[i] == user_code[i]
        @answer << '+'
        sc[i] = 0
        user_code[i] = "0"
      end
      end
    for x in 0...CODE_SIZE
        
      for y in 0...CODE_SIZE
        if sc[x] <=> '0' && sc[x] == user_code[y]
          @answer << '-'
          sc[x] = 0
          user_code[y] = '0'
        end
      end

    end
    @answer
    end

    def requests_hint(user_id)
      @secret_code = self.get_secred_code(user_id)
      rand_number = Random.new.rand(0...CODE_SIZE-1)
      @hint_code = @hint_code.split ''
      @hint_code[rand_number] = @secret_code[rand_number]
      self.update_hint(@hint_code.join, user_id)
      return @hint_code.join
    end

    def save_new_values(user_name, attempts)
      self.start
      @data = [ 
               user_name:      user_name, 
               attempts:       attempts.to_i, 
               hint_code:      @hint_code, 
               attempts_count: 0, 
               secret_code:    @secret_code,
               game_condition: 0,
               start_time:     Time.new().to_i
              ]
      File.open("./data/#{@user_id}.txt", 'w') { |file| file.write(YAML.dump(@data)) }
    end

    def get_user_info(file_name)
      YAML.load(File.open("./data/#{file_name}.txt"))
    end

    def update_hint(hint, user_id)
      @data = YAML.load(File.open("./data/#{user_id}.txt"))
      @data[0][:hint_code] = hint
      File.open("./data/#{user_id}.txt", 'w') { |file| file.write(YAML.dump(@data)) }
    end

    def update_condition(condition, user_id)
      @data = YAML.load(File.open("./data/#{user_id}.txt"))
      @data[0][:game_condition] = condition
      File.open("./data/#{user_id}.txt", 'w') { |file| file.write(YAML.dump(@data)) }
    end

    def update_value(user_id, user_code, result)
      @data = YAML.load(File.open("./data/#{user_id}.txt"))
      @data[0][:attempts_count] += 1
      @data << [user_code, result]
      File.open("./data/#{user_id}.txt", 'w') { |file| file.write(YAML.dump(@data)) }
    end

    def save_result(user_id)
      @user_info = YAML.load(File.open("./data/#{user_id}.txt"))
      @data = YAML.load(File.open("./data/save_result.txt"))
      @data << [ 
        user_name: @user_info[0][:user_name], 
        time: Time.new().to_i - @user_info[0][:start_time].to_i 
      ]
      File.open("./data/save_result.txt", 'w') { |file| file.write(YAML.dump(@data)) }
    end
  
  end
end
