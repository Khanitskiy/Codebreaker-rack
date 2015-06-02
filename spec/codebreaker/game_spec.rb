require 'spec_helper'
 
module Codebreaker
  describe Game do
    context "Start game" do
      let(:game) { Game.new }
 
      before do
        game.start
      end
 
      it "saves secret code" do
        expect(game.instance_variable_get(:@secret_code)).not_to be_empty
      end
 
      it "saves 4 numbers secret code" do
        expect(game.instance_variable_get(:@secret_code)).to have(4).items
      end
 
      it "saves secret code with numbers from 1 to 6" do
      	expect(game.instance_variable_get(:@secret_code)).to_not include('0','7','8','9')
      end

    end

    context "Setting parametrs" do
      let(:game) { Game.new }
 
      before do
        game.start
        game.attempts = 10
      end

      it "Setting the number of attempts" do
      	expect(game.instance_variable_get(:@attempts)).to_not be_nil
      end

      it "Setting the number of attempts is not more than 10" do
      	expect(game.instance_variable_get(:@attempts)).to be < 11
      end

      it "Comparison of the secret code with user's code" do 
      	game.user_code_split '1234'
      	game.instance_variable_set(:@secret_code, ["1","2","3","4"])
      	expect(game.instance_variable_get(:@secret_code)).to eq(game.instance_variable_get(:@user_code))
      end

      it "Convert string user's code to array user's code" do
      	expect(game.user_code_split('1234')).to eq(["1","2","3","4"])
      end
    end

    context "Request a hint" do
      let(:game) { Game.new }
 
      before do
        game.start
      end
      
      it "Request a hint return three \"*\"" do
      	requests_hint = game.requests_hint.split ''
      	requests_hint = requests_hint.each_with_object(Hash.new(0)) {|word, hash| hash[word] += 1}
      	expect(requests_hint['*']).to eq(3)
      end

      it "If Request a hint else change flag using hint" do
        game.requests_hint
        expect(game.hint).to be true 
      end

       it "If twice call requests_hint returns the same result" do
        first_call = game.requests_hint
        expect(game.requests_hint).to eq(first_call)
      end
    end

    context "Return answer" do
      let(:game) { Game.new }
 
      before do
        game.start
        game.attempts = 1
        game.instance_variable_set(:@secret_code, ["1","2","3","4"])
      end

      it "Check return \"+\"" do
      	expect('+').to eq game.comparison_codes('1555')
      end

      it "Check return \"++\"" do
      	expect('++').to eq game.comparison_codes('1255')
      end

      it "Check return \"+++\"" do
      	expect('+++').to eq game.comparison_codes('1235')
      end

      it "Check return \"+++-\"" do
      	expect('++--').to eq game.comparison_codes('1243')
      end

      it "Check return \"++-\"" do
      	expect('++-').to eq game.comparison_codes('1245')
      end

      it "Check return \"+--\"" do
      	expect('+--').to eq game.comparison_codes('1345')
      end

      it "Check return \"+-\"" do
      	expect('+-').to eq game.comparison_codes('1552')
      end

      it "Check return \"-\"" do
      	expect('-').to eq game.comparison_codes('6661')
      end

      it "Check return \"--\"" do
      	expect('--').to eq game.comparison_codes('6621')
      end

      it "Check return \"---\"" do
      	expect('---').to eq game.comparison_codes('6321')
      end

      it "Check return \"----\"" do
      	expect('----').to eq game.comparison_codes('4321')
      end

      it "Check return \"user's win\"" do
      	expect(true).to eq game.comparison_codes('1234')
      end

      it "Check return \"losing user\"" do
      	game.comparison_codes('3333')
      	expect(game.comparison_codes('2341')).to be_falsey
      end

      it "Checking the number of attempts to change the counter" do
        expect{game.comparison_codes '1552' }.to change{ game.instance_variable_get(:@attempts_count) }.to 1
      end

    end


  end
end