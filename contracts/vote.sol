pragma solidity >=0.5.0 <0.6.0;

contract Nva {
    Candidat[] candidats;
    Match[] matchs;
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
        Vote[] votes;
        Candidat homeCandidat;
        Candidat awayCandidat;
        uint32 date;
    }
    struct Ligue {
        Candidat[] participants;
        Match[] matchs;
        Candidat winner;
    }
    function addCandidat(string memory _partie, string memory _nom, string memory _prenom) public {
        candidats.push(Candidat(_partie, _nom, _prenom, msg.sender, 0, 0, 0));
    }
    function getCandidatParti(uint candidatId) public view returns (string memory) {
        return candidats[candidatId].parti;
    }
    function getCandidatNom(uint candidatId) public view returns (string memory) {
        return candidats[candidatId].nom;
    }
    function getCandidatPrenom(uint candidatId) public view returns (string memory) {
        return candidats[candidatId].prenom;
    }
    function getCandidatVictoires(uint candidatId) public view returns (uint) {
        return candidats[candidatId].victoires;
    }
    function getCandidatDefaites(uint candidatId) public view returns (uint) {
        return candidats[candidatId].defaites;
    }
    function getCandidatNuls(uint candidatId) public view returns (uint) {
        return candidats[candidatId].nuls;
    }
    function addVictoire(uint candidatId) public {
        candidats[candidatId].victoires = candidats[candidatId].victoires + 1;
    }
    function addDefaite(uint candidatId) public {
        candidats[candidatId].defaites = candidats[candidatId].defaites + 1;
    }
    function addNul(uint candidatId) public {
        candidats[candidatId].nuls = candidats[candidatId].nuls + 1;
    }
    function voteByUser(uint candidatId, uint matchId) public {
        matchs[matchId].votes.push(Vote(msg.sender, candidats[candidatId].id));
    }
    function createMatch(uint premCandidatId, uint secCandidatId, uint32 date) private {
        Vote[] memory votes;
        matchs.push(Match(votes, candidats[premCandidatId], candidats[secCandidatId], date));
    }
}