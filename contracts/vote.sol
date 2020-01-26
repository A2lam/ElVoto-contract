pragma solidity >=0.6.0;

contract nva {

    Candidat[] candidats;
    Ligue ligue;
    uint nbCandidats;

    Ligue[] pastLigues;

     struct Candidat {
        string parti;
        string nom;
        string prenom;
        address id;
        uint victoires;
        uint defaites;
        uint nuls;
    }
    struct Vote {
        address votant;
        address candidat;
    }
    struct Match {
        mapping (uint => Vote) votes;
        uint nbVotes;
        uint homeCandidatId;
        uint awayCandidatId;
    }
    struct Ligue {
        mapping (uint => Match) matchs;
        uint nbMatchs;
        uint winnerId;
    }

//Ligue
    function initLigue()  public {
        pastLigues.push(ligue);
        ligue = Ligue(0, 0);
    }

    function incrementCurrentLigueNbMatch() public {
        ligue.nbMatchs ++;
    }
    function calculateLigueWinner() public {
        uint winnerId = 0;
        uint maxPoints = 0;
        uint points = 0;
        uint i = 0;

        while(i < nbCandidats){
            points += 3 * getCandidatVictoires(i);
            points += 1 * getCandidatNuls(i);
            if (points > maxPoints){
                winnerId = i;
                maxPoints = points;
            }
            points = 0;
        }

       ligue.winnerId = winnerId;
    }
    function getLigueWinnerId() public view returns(uint) {
        return ligue.winnerId;
    }

//Match
    function vote(uint matchId, uint candidatId) public {
        uint i = getMatchNbVotes(matchId);
        ligue.matchs[matchId].votes[i] = Vote(msg.sender, getCandidatAddress(candidatId));
        incrementMatchNbVotes(matchId);
    }

    function addMatch(uint _homeCandidatId, uint _awayCandidatId) public {
        Match memory game;
        game.homeCandidatId = _homeCandidatId;
        game.awayCandidatId = _awayCandidatId;
        game.nbVotes = 0;
        ligue.matchs[ligue.nbMatchs] = game;
        incrementCurrentLigueNbMatch();
    }

    function matchResult(uint matchId) public {
        uint nbVotes = getMatchNbVotes(matchId);
        uint i = 0;
        uint homeCandidatId = getMatchHomeCandidatId(matchId);
        uint awayCandidatId = getMatchAwayCandidatId(matchId);
        address homeCandidat = getCandidatAddress(homeCandidatId);
        uint homeCandidatVotes = 0;
        uint awayCandidatVotes = 0;

        while(i < nbVotes){
            if(ligue.matchs[matchId].votes[i].candidat == homeCandidat){
                homeCandidatVotes ++;
            }
            else{
                awayCandidatVotes ++;
            }
            i++;
        }
        if(homeCandidatVotes > awayCandidatVotes){
            addVictoire(homeCandidatId);
            addDefaite(awayCandidatId);
        }
        else if(homeCandidatVotes < awayCandidatVotes){
            addVictoire(awayCandidatId);
            addDefaite(homeCandidatId);
        }
        else{
            addNul(homeCandidatId);
            addNul(awayCandidatId);
        }
    }

    function getMatchHomeCandidatId(uint matchId) public view returns (uint){
        return ligue.matchs[matchId].homeCandidatId;
    }
    function getMatchAwayCandidatId(uint matchId) public view returns (uint){
        return ligue.matchs[matchId].awayCandidatId;
    }
    function getMatchNbVotes(uint matchId) public view returns (uint){
        return ligue.matchs[matchId].nbVotes;
    }
    function incrementMatchNbVotes(uint matchId) public {
        ligue.matchs[matchId].nbVotes ++;
    }

//Candidat
    function addCandidat(string memory _parti, string memory _nom, string memory _prenom) public {
        candidats.push(Candidat(_parti, _nom, _prenom, msg.sender, 0, 0, 0));
    }

    function getCandidatAddress(uint candidatId) public view returns (address){
        return candidats[candidatId].id;
    }

    function getCandidatParti(uint candidatId) public view returns (string memory){
        return candidats[candidatId].parti;
    }

     function getCandidatNom(uint candidatId) public view returns (string memory){
        return candidats[candidatId].nom;
    }

     function getCandidatPrenom(uint candidatId) public view returns (string memory){
        return candidats[candidatId].prenom;
    }

    function getCandidatVictoires(uint candidatId) public view returns (uint){
        return candidats[candidatId].victoires;
    }
    function getCandidatDefaites(uint candidatId) public view returns (uint){
        return candidats[candidatId].defaites;
    }
    function getCandidatNuls(uint candidatId) public view returns (uint){
        return candidats[candidatId].nuls;
    }

    function addVictoire(uint candidatId) public{
        candidats[candidatId].victoires = candidats[candidatId].victoires + 1;
    }

    function addDefaite(uint candidatId) public{
        candidats[candidatId].defaites = candidats[candidatId].defaites + 1;
    }
    function addNul(uint candidatId) public{
        candidats[candidatId].nuls = candidats[candidatId].nuls + 1;
    }

}