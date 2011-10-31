require 'spec_helper'

describe SidePot do
   before do
      @player1 = mock 'Player'
      @player2 = mock 'Player'
   end
   
   describe 'knows the players that have added to its value' do
      it 'when it is first created' do
         setup_succeeding_test
      end
      it 'when a player makes a bet' do
         (patient, players_and_their_contributions) = setup_succeeding_test
         (patient, players_and_their_contributions) = calling_test patient, players_and_their_contributions
         
         betting_test patient, players_and_their_contributions
      end
      it 'when a player calls the current bet' do
         (patient, players_and_their_contributions) = setup_succeeding_test
         
         calling_test patient, players_and_their_contributions
      end
      it 'when a player raises the current bet' do
         (patient, players_and_their_contributions) = setup_succeeding_test
         (patient, players_and_their_contributions) = calling_test patient, players_and_their_contributions
         (patient, players_and_their_contributions) = betting_test patient, players_and_their_contributions
         
         raising_test patient, players_and_their_contributions
      end
   end
   
   describe 'keeps track of the amount that has been added to its value' do
      it 'when it is first created' do
         (patient,) = setup_succeeding_test
         
         patient.value.should be == @initial_amount_in_side_pot
      end
      it 'when a player makes a bet' do
         (patient, players_and_their_contributions) = setup_succeeding_test
         (patient, players_and_their_contributions) = calling_test patient, players_and_their_contributions
         
         (patient,) = betting_test patient, players_and_their_contributions
         
         patient.value.should be == 2 * @initial_amount_in_side_pot + @amount_to_bet
      end
      it 'when a player calls the current bet' do
         (patient, players_and_their_contributions) = setup_succeeding_test
         
         (patient,) = calling_test patient, players_and_their_contributions
         
         patient.value.should be == 2 * @initial_amount_in_side_pot
      end
      it 'when a player raises the current bet' do
         (patient, players_and_their_contributions) = setup_succeeding_test
         (patient, players_and_their_contributions) = calling_test patient, players_and_their_contributions
         (patient, players_and_their_contributions) = betting_test patient, players_and_their_contributions
         
         (patient,) = raising_test patient, players_and_their_contributions
         
         patient.value.should be == 2 * (@initial_amount_in_side_pot + @amount_to_bet) + @amount_to_raise_by
      end
   end
   
   describe '#distribute_chips!' do
      it 'distributes chips properly when only one player involved has not folded' do
         (patient, players_and_their_contributions) = setup_succeeding_test
         (patient, players_and_their_contributions) = calling_test patient, players_and_their_contributions
         (patient,) = betting_test patient, players_and_their_contributions
         
         chips_to_distribute = 2 * @initial_amount_in_side_pot + @amount_to_bet
         patient.value.should be == chips_to_distribute
         
         @player1.stubs(:has_folded).returns(false)
         @player2.stubs(:has_folded).returns(true)
         @player1.expects(:take_winnings!).once.with(chips_to_distribute)
         
         test_chip_distribution patient, players_and_their_contributions
      end
      it 'distributes the chips it contains properly to two players that have not folded and have equal hand strength' do
         (patient, players_and_their_contributions) = setup_succeeding_test
         (patient, players_and_their_contributions) = calling_test patient, players_and_their_contributions
         (patient,) = betting_test patient, players_and_their_contributions
         
         chips_to_distribute = 2 * @initial_amount_in_side_pot + @amount_to_bet
         patient.value.should be == chips_to_distribute
         
         @player1.stubs(:has_folded).returns(false)
         @player2.stubs(:has_folded).returns(false)
         poker_hand_strength = 5
         @player1.stubs(:poker_hand_strength).returns(poker_hand_strength)
         @player2.stubs(:poker_hand_strength).returns(poker_hand_strength)
         @player1.expects(:take_winnings!).once.with(chips_to_distribute/2.0)
         @player2.expects(:take_winnings!).once.with(chips_to_distribute/2.0)
         
         
         test_chip_distribution patient, players_and_their_contributions
      end
      it 'distributes the chips it contains properly to two players that have not folded and have unequal hand strength' do
         (patient, players_and_their_contributions) = setup_succeeding_test
         (patient, players_and_their_contributions) = calling_test patient, players_and_their_contributions
         (patient,) = betting_test patient, players_and_their_contributions
         
         chips_to_distribute = 2 * @initial_amount_in_side_pot + @amount_to_bet
         patient.value.should be == chips_to_distribute
         
         @player1.stubs(:has_folded).returns(false)
         @player2.stubs(:has_folded).returns(false)
         @player1.stubs(:poker_hand_strength).returns(10)
         @player2.stubs(:poker_hand_strength).returns(9)
         @player1.expects(:take_winnings!).once.with(chips_to_distribute)
         
         test_chip_distribution patient, players_and_their_contributions
      end
      it 'raises an exception if there are no chips to distribute' do
         initial_amount_in_side_pot = 0
         @player1.expects(:take_from_stack!).once.with(initial_amount_in_side_pot)
      
         patient = SidePot.new @player1, initial_amount_in_side_pot
      
         players_and_their_contributions = {@player1 => initial_amount_in_side_pot}
      
         patient.players_involved_and_their_amounts_contributed.should eq(players_and_their_contributions)
         
         expect{patient.distribute_chips!}.to raise_exception(SidePot::NoChipsToDistribute)
      end
      it 'raises an exception if there are no players to take chips' do
         pending 'multiplayer support'
         #expect{patient.distribute_chips!}.to raise_exception(SidePot::NoPlayersToTakeChips)
      end
   end
   
   def setup_succeeding_test
      @initial_amount_in_side_pot = 10
      @player1.expects(:take_from_stack!).once.with(@initial_amount_in_side_pot)
      
      patient = SidePot.new @player1, @initial_amount_in_side_pot
      
      players_and_their_contributions = {@player1 => @initial_amount_in_side_pot}
      
      patient.players_involved_and_their_amounts_contributed.should be == players_and_their_contributions
      
      [patient, players_and_their_contributions]
   end
   
   def calling_test(patient, players_and_their_contributions)
      @player2.expects(:take_from_stack!).once.with(@initial_amount_in_side_pot)
      players_and_their_contributions[@player2] = @initial_amount_in_side_pot
      
      patient.take_call! @player2
         
      patient.players_involved_and_their_amounts_contributed.should be == players_and_their_contributions
      
      [patient, players_and_their_contributions]
   end
   
   def betting_test(patient, players_and_their_contributions)
      @amount_to_bet = 34
      @player1.expects(:take_from_stack!).once.with(@amount_to_bet)
      players_and_their_contributions[@player1] += @amount_to_bet
      
      patient.take_bet! @player1, @amount_to_bet
      
      patient.players_involved_and_their_amounts_contributed.should be == players_and_their_contributions
      
      [patient, players_and_their_contributions]
   end
   
   def raising_test(patient, players_and_their_contributions)
      @amount_to_raise_by = 22
      @total_amount = @amount_to_raise_by + @amount_to_bet + @initial_amount_in_side_pot
      
      @player2.expects(:take_from_stack!).once.with(@amount_to_bet)
      @player2.expects(:take_from_stack!).once.with(@amount_to_raise_by)
      
      players_and_their_contributions[@player2] = @total_amount
      
      patient.take_raise! @player2, @amount_to_raise_by
      
      patient.players_involved_and_their_amounts_contributed.should be == players_and_their_contributions
      
      [patient, players_and_their_contributions]
   end
   
   def test_chip_distribution(patient, players_and_their_contributions)
      players_and_their_contributions = {}
         
      patient.distribute_chips!
         
      patient.value.should be == 0
      patient.players_involved_and_their_amounts_contributed.should be == players_and_their_contributions
      
      [patient, players_and_their_contributions]
   end
end