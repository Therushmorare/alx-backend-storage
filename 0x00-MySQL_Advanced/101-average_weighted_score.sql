-- Create the stored procedure ComputeAverageWeightedScoreForUsers
DELIMITER //

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE user_id INT;
    DECLARE total_score FLOAT;
    DECLARE total_weight FLOAT;
    DECLARE avg_score FLOAT;

    -- Cursor declaration
    DECLARE cur CURSOR FOR 
        SELECT u.id
        FROM users u;

    -- Declare handler for the cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Open the cursor
    OPEN cur;

    -- Loop through each user
    user_loop: LOOP
        -- Fetch next user_id from the cursor
        FETCH cur INTO user_id;
        
        -- Check if done fetching
        IF done THEN
            LEAVE user_loop;
        END IF;

        -- Initialize total score and total weight for the user
        SET total_score = 0;
        SET total_weight = 0;
        
        -- Calculate total weighted score and total weight for the user
        SELECT SUM(c.score * p.weight), SUM(p.weight)
        INTO total_score, total_weight
        FROM corrections c
        JOIN projects p ON c.project_id = p.id
        WHERE c.user_id = user_id;
        
        -- Calculate average weighted score for the user
        IF total_weight > 0 THEN
            SET avg_score = total_score / total_weight;
        ELSE
            SET avg_score = 0;
        END IF;

        -- Update the average score for the user
        UPDATE users
        SET average_score = avg_score
        WHERE id = user_id;
    END LOOP;

    -- Close the cursor
    CLOSE cur;
END //

DELIMITER ;

