import random

def one_instance():
    box1 = ['R']*6 + ['B']*4
    box2 = ['R']*7 + ['B']*3

    # Randomly select one ball from box 1 and move it to box 2
    ball_from_box1 = random.choice(box1)
    box1.remove(ball_from_box1)
    box2.append(ball_from_box1)

    # Randomly select one ball from box 2 and move it to box 1
    ball_from_box2 = random.choice(box2)
    box2.remove(ball_from_box2)
    box1.append(ball_from_box2)

    return ball_from_box1, ball_from_box2, box1.count('R'), box1.count('B'), box2.count('R'), box2.count('B')

print(one_instance())

n_simulations = 10000

# Initialize empty lists to store the results
swaps = []
final_counts = []

# Counters for specific outcomes
count_RR = 0
count_same_proportion = 0

for _ in range(n_simulations):
    result = one_instance()
    swaps.append([result[0], result[1]])
    final_counts.append([result[2], result[3], result[4], result[5]])

    # Check if a red ball is selected from both boxes
    if result[0] == 'R' and result[1] == 'R':
        count_RR += 1
    
    # Check if the boxes have the same proportion of balls after the swaps
    if result[2] == 6 and result[3] == 4 and result[4] == 7 and result[5] == 3:
        count_same_proportion += 1

# Calculate probabilities
prob_RR = count_RR / n_simulations
prob_same_proportion = count_same_proportion / n_simulations

print(f"Simulated probability of selecting a red ball from both boxes: {prob_RR}")
print(f"Simulated probability of having the same proportion after the swaps: {prob_same_proportion}")